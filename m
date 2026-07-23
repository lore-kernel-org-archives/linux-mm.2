Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DE14C44536
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 00:42:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 234146B00B3; Wed, 22 Jul 2026 20:42:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20B396B00B4; Wed, 22 Jul 2026 20:42:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FD256B00B7; Wed, 22 Jul 2026 20:42:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C43CB6B00B3
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 20:42:40 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2092C1A0319
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:42:40 +0000 (UTC)
X-FDA: 85018190880.28.B51C972
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	by imf09.hostedemail.com (Postfix) with ESMTP id E3C7E140008
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:42:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmx.com header.s=s31663417 header.b=OMFZh65i;
	spf=pass (imf09.hostedemail.com: domain of quwenruo.btrfs@gmx.com designates 212.227.17.22 as permitted sender) smtp.mailfrom=quwenruo.btrfs@gmx.com;
	dmarc=pass (policy=quarantine) header.from=gmx.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784767358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=72rD37V4RsYtifWkhcvHdKCeXRydgQkWFU7HsaPnWjQ=;
	b=j5spYPRyZj8OKpo0uT19XXCUaB+SykX9hc7qk/yaX4QJ3S6/7C2AVLTH4FTpr096XHr8SK
	1jM/jWxYkC2vf+Svpz2eJpnmZkKjRnN07YVUKO7DQm2C+sQ3zSRUlNbGbaqItQ2TC8vV7A
	kk0DU1Emz5pOj0aJHO3iNjb3cYzW5m0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784767358;
	b=vuEdvqbaZUrsbSl+Lqb/NPQ4PCyzvaKLX0HIve0EXua0ATHxn0Jcjc8tQQN2aDTVtnCYRQ
	5n3+DWea8KB/HJ3UBEoZLOgFq/xsuLEOxlgru6/IGJY+TSE1HapyA3iv3fREGSJAtADMjW
	ghpb+GxwiFII7Y2kQa+ov0WBTbyXKq4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmx.com header.s=s31663417 header.b=OMFZh65i;
	spf=pass (imf09.hostedemail.com: domain of quwenruo.btrfs@gmx.com designates 212.227.17.22 as permitted sender) smtp.mailfrom=quwenruo.btrfs@gmx.com;
	dmarc=pass (policy=quarantine) header.from=gmx.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1784767356; x=1785372156; i=quwenruo.btrfs@gmx.com;
	bh=72rD37V4RsYtifWkhcvHdKCeXRydgQkWFU7HsaPnWjQ=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=OMFZh65inZssy3Hx1YaD4ut7t9/gOoIxUhZgAd7+R28JcZlfjiTl5iMYd3+b5fbO
	 vZmVaZVLlQ63aTQ7lnDsICwE+TslMDFrod1wip4xWoJG3DactWBt9214EoW5vBCZy
	 HMACVR53MD7sCENhSUFYACUlbfwf0irt0TZeL9+dzPP9KZA6WB9+EgwaxjAlDBCrk
	 C7qIBvzg5AaUeahQZ+RdLlXE11ZseLkfkukewwz3zVsQwZu9Tdo8V6cTa+PcyWWD7
	 j0K49zbYd4WpkOmXepXoU4i6ISseQBBlqDsTUXtrsnfXTK5blmhlla0pBO2mwabPu
	 dczlDUyLyfN7uKciLw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MTRMi-1wPVn51qF2-00QU0L; Thu, 23
 Jul 2026 02:42:36 +0200
Message-ID: <ad6eebbd-07f8-41ce-b04c-edd50d91a6e3@gmx.com>
Date: Thu, 23 Jul 2026 10:12:27 +0930
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH/RFC] btrfs: fix folio lock leak in writepage_delalloc()
 for folios dirtied behind btrfs' back
To: Matthew Wilcox <willy@infradead.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
 Linux Memory Management List <linux-mm@kvack.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
 Josef Bacik <josef@toxicpanda.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20260721191152.101118-1-borntraeger@linux.ibm.com>
 <20260721191152.101118-2-borntraeger@linux.ibm.com>
 <b226a6e9-fef2-49bd-b17e-9f9b015626c1@gmx.com>
 <83290932-cb8b-4741-bff0-6a7d8df2c637@linux.ibm.com>
 <224d56d2-fcad-41bf-afe3-6f5f5108172a@gmx.com>
 <f12f70e5-d84d-4a9f-ac94-693be4c863ac@linux.ibm.com>
 <amC-J7yzwk4Z5tHW@casper.infradead.org>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1YAUJEP5a
 sQAKCRDCPZHzoSX+qF+mB/9gXu9C3BV0omDZBDWevJHxpWpOwQ8DxZEbk9b9LcrQlWdhFhyn
 xi+l5lRziV9ZGyYXp7N35a9t7GQJndMCFUWYoEa+1NCuxDs6bslfrCaGEGG/+wd6oIPb85xo
 naxnQ+SQtYLUFbU77WkUPaaIU8hH2BAfn9ZSDX9lIxheQE8ZYGGmo4wYpnN7/hSXALD7+oun
 tZljjGNT1o+/B8WVZtw/YZuCuHgZeaFdhcV2jsz7+iGb+LsqzHuznrXqbyUQgQT9kn8ZYFNW
 7tf+LNxXuwedzRag4fxtR+5GVvJ41Oh/eygp8VqiMAtnFYaSlb9sjia1Mh+m+OBFeuXjgGlG
 VvQFzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1gQUJEP5a0gAK
 CRDCPZHzoSX+qHGpB/kB8A7M7KGL5qzat+jBRoLwB0Y3Zax0QWuANVdZM3eJDlKJKJ4HKzjo
 B2Pcn4JXL2apSan2uJftaMbNQbwotvabLXkE7cPpnppnBq7iovmBw++/d8zQjLQLWInQ5kNq
 Vmi36kmq8o5c0f97QVjMryHlmSlEZ2Wwc1kURAe4lsRG2dNeAd4CAqmTw0cMIrR6R/Dpt3ma
 +8oGXJOmwWuDFKNV4G2XLKcghqrtcRf2zAGNogg3KulCykHHripG3kPKsb7fYVcSQtlt5R6v
 HZStaZBzw4PcDiaAF3pPDBd+0fIKS6BlpeNRSFG94RYrt84Qw77JWDOAZsyNfEIEE0J6LSR/
In-Reply-To: <amC-J7yzwk4Z5tHW@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:+MEPxw/Y1t5b82ICW+5xecgHp44NMWCYm9Zbs65/tr5kGBev5Kg
 pxui9HwSy3xzbFU8Rge/Eb/VbVj5V3gWbjtn5G2O2yce0WGRIj8xV7atsB9EsLqpKJripMU
 hY7KyioLTP/E1r1Ggr85kotDxr7w52h6RhAnLaYK6P/YtFBdbNMhxiSezwSFubN2ZUOKI6Y
 yw/QxGcJra/1956LbovaA==
UI-OutboundReport: notjunk:1;M01:P0:HjO7+iri6Bk=;mCqRS1TkiIZII7I5qK1q6kM244g
 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
 3qDGTKIX2HduD6/QZdNXwvOMMQutEbJxC+OeAoy
X-Stat-Signature: andbrmso478t4e7yda589m4p8mnz6r9d
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E3C7E140008
X-HE-Tag: 1784767357-593998
X-HE-Meta: U2FsdGVkX1+dozHSCLgamI4SQfycEO/mXAkATFDkARIv4EdZ9JmSZTrN2xf1NUeN6RhLUt9V4zlJsjb8fiJ50A3l/L9lNESnX9mWlnhSl8Q8bUpwwFjWqI2xV2/IT5Z3H1cAh5kWUb6KQj4ST1p4S1QLU64p5YyCwSVYVUT7+m+yOiqxNyJ9W6iR25JkgjpJmnd6jPBT9S52JYJXFetIQEpofSH3ZXTl++w+B3+AMNVXBWHkeyaGZejuXaYNJ9dpmgjZa7dxR8HW6TfyszfG3KX6Qz6yYOwDTeHpI189AQaCcxeYQdvUlzmRtHSKQ/waPcdGMdcgdWa45+46A1krKBNBcH3ptaf4hF7PPtXDX+SxllxfIbgfE7lTnpdf2cTm+RrJningeSO/7QkV6r1sTe/T1at3zQ1pO2mzR0JshOhJT59Is/NBmgx7yQFcfT1OfcQBvkQi2LbIJG9VpVFT1FDnQ5viTjV61/MoECrevYVIxdyJuHaR0VOOEKid6oAxZkEXLM81jgLBB0AazfXNiGTxuHxg/bXWyK0cc4AA47jOjxfBcX41oYyqEc9QkD6DZ88JEEjbT0gB79Ia3y2bRpjsooyWaei17yOtTp/R179lKliSuEQrdTua7XiVF3GmdQiSYf/7sevEP9eBtlitw/apH6ZSK0iYPLp8jAtoHHN/Dip8XG8+ZA4/sMNOpkk6e1bziNcdi5yLcHrGd44KIGjlheN4QwWTZl39vZ9K69+ADtgBn+pDQT4sZePYLdCO+4kKhy6m4EBYpbBQeTZBi7ExGRe4oqFBxAi8NimVj5MlHUa9rKqJxIH2/vKQrO9VojSGGs4hO73SR2vRWMi2/HHwx58TTtS+9um90Z72JxptUTdLK9bLgHRF5pUOCFpafyEvjyXEhB/VybfF39AdYXRiSnDylzFuJLY2PeDs9iK/vb27zuXfvLX8lpR7W+Ruy7kShYvD3GVNrgCTFIy
 jWuPtOHA
 zusS8QEgZW4ebKpm0WBE4IK2x0dU5RQoTzg//+h59Cbb+xFQDgYUc/YML+yc7NGIr3q1l9uCry3/bU8Eti8bQK/VeUxrSIM8ghyZ3eb18M0TEMQVfwFKvqZRmwGZNmN3q3lxK0hU001Zpf+4jfXp8hwhhSCn20KyDTi1sKWjqJCu1/74bvt6RFbcSWPOBSZoqL7aijbg2B6HQa8xBMo06Jz+T4KxRznIq59hPOgwIohxNttabCwBhaBHztSTWNmo9CkX9kYksr0rXzIgrs3CGUPyT585J+QxdpBH8FiNeyBoV0ZHyCiyfJ0K5+oSOXLNkXyAu3SJU0iy5SYDOZS5CpID5c0QwmZAuXVinD33qqdNd/xYspkXXHw+tsM+KOioFbBVkMUUBKxCo8q1FkBd0YFU+xkZ7Jm8ia/HLqTBfC9oNRPc1JgL5+zVXmg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



=E5=9C=A8 2026/7/22 22:27, Matthew Wilcox =E5=86=99=E9=81=93:
> On Wed, Jul 22, 2026 at 11:29:36AM +0200, Christian Borntraeger wrote:
>>   *   4. Thread B loops sync_file_range(WRITE|WAIT) on the target file.
>>   *      Whenever a full clean cycle (clear_page_dirty_for_io(),
>>   *      writeback, bits cleared) completes inside thread A's
>>   *      submission->completion window, the completion-time
>>   *      set_page_dirty_lock() hits a *clean* folio: filemap_dirty_foli=
o()
>>   *      sets only the folio flag and the xarray tag - no btrfs subpage
>>   *      dirty bit, no delalloc reservation.  See the 20-year-old comme=
nt
>>   *      above bio_set_pages_dirty() in block/bio.c describing exactly
>>   *      this ("other code (eg, flusher threads) could clean the pages"=
).
>=20
> There's your problem.  filemap_dirty_folio() documents that btrfs is
> doing it wrongly:
>=20
>   * Filesystems which do not use buffer heads should call this function
>   * from their dirty_folio address space operation.  It ignores the
>   * contents of folio_get_private(), so if the filesystem marks individu=
al
>   * blocks as dirty, the filesystem should handle that itself.
>=20
> fs/btrfs/inode.c:       .dirty_folio    =3D filemap_dirty_folio,
>=20
> so btrfs should have its own btrfs_dirty_folio() which does whatever
> metadata updates it needs to and then call filemap_dirty_folio() to
> take care of the page cache business.  See iomap_dirty_folio() as
> an example, but many other filesystems also do this.

Thanks a lot for the advice.

However it looks like the sub-folio dirty block tracking is a little=20
different between iomap and btrfs.

E.g. iomap will mark the full folio range dirty even if the EOF is=20
inside the folio, but btrfs will only mark the range inside EOF as dirty.


Another thing is, even if we follow iomap to mark the full folio dirty,=20
it's still not the end of the story.

We have other supporting mechanisms required to tracking the dirty=20
range. E.g. EXTENT_DELALLOC flags inside extent-io-tree, indicating we=20
have already reserved space for the dirty range.

Only with EXTENT_DELALLOC flag set, we will do the real delayed=20
allocation, allocating the on-disk extents etc.

So even if we always mark the full folio dirty, the writeback path will=20
not handle them correctly either.


Finally, even without large folios, the reproducer can already cause=20
problems on btrfs. E.g. on x86_64, with mapping_set_folio_order_range()=20
disabled.

The symptom there is that, ordered extent accounting underflows, which=20
may also contribute to the stall observed.

I'll keep digging for this bug.

Thanks,
Qu


