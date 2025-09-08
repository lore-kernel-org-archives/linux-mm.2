Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B210CCA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 15:09:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E0C08E0011; Mon,  8 Sep 2025 11:09:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16B1B8E0001; Mon,  8 Sep 2025 11:09:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0595A8E0011; Mon,  8 Sep 2025 11:09:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DFBE18E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:09:39 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 80AB8C0179
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:09:39 +0000 (UTC)
X-FDA: 83866417278.15.63DEDAF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id A76C84000E
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:09:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DL2sZetd;
	spf=pass (imf07.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757344177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=heQQ3Ud2LMh6YOFJjpOWIBQv+t67vvA52HA8Ei7ieDs=;
	b=z7wJJbVFrqharvpebsWVl+B1F5zUfxX6TUPJ81gDuUeSjiPxlnNY4J62RzvKVgR+zxGW0e
	ccSHxeSd8yVVQYOZMjOqqUBL5hjEcj8S3q/qMZ2vgN0YQt/q6BaqX7ea0dh5Ua/K/z+cBA
	WGfkhNOQL96uX+lbwXGa6SKkPZMdl+U=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DL2sZetd;
	spf=pass (imf07.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757344177; a=rsa-sha256;
	cv=none;
	b=BZBbR4B87He8FEC6T08E5Ps/khmlloqgoyE9YBAYiBb27gds8jqqWW1EGpZd+YCiEj7njK
	aSFJ1TCDc6XlA/nCzW536rvl/yegXlIX2ztDRkp3v4FSi+MfjxcJuh20n9i4WZdKXT0o2j
	aLkYT3aWaTRKig2mftSOSchgYJ5fk4w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757344177;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=heQQ3Ud2LMh6YOFJjpOWIBQv+t67vvA52HA8Ei7ieDs=;
	b=DL2sZetdOPz21Jfbpdb3ubXW5apvQzOPOnqyrnvs2QLLTTwO8dMdzEy6Umi5Q4TemT1Mrt
	2YYCr6sJ6WiRV0OdSc6DgSzrGKD3YbmQsd/oV0VtvKdRhzohuGDHnyZ+zsX62r6CnXDgLz
	uyV71ZROnM+CaFgJA2Gle7c4o0HeEjU=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-453-mbUoeq_OML650TvnQs5P0Q-1; Mon,
 08 Sep 2025 11:09:32 -0400
X-MC-Unique: mbUoeq_OML650TvnQs5P0Q-1
X-Mimecast-MFC-AGG-ID: mbUoeq_OML650TvnQs5P0Q_1757344170
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D324D19560AE;
	Mon,  8 Sep 2025 15:09:29 +0000 (UTC)
Received: from localhost (unknown [10.72.112.11])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E389D1800451;
	Mon,  8 Sep 2025 15:09:26 +0000 (UTC)
Date: Mon, 8 Sep 2025 23:09:22 +0800
From: Baoquan He <bhe@redhat.com>
To: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@redhat.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/15] docs/mm: add document for swap table
Message-ID: <aL7xoiTacg0vCLjz@MiWiFi-R3L-srv>
References: <20250905191357.78298-1-ryncsn@gmail.com>
 <20250905191357.78298-2-ryncsn@gmail.com>
 <aL7NrhGw5ftOXUZs@MiWiFi-R3L-srv>
 <CACePvbXi3Avsic62fMdhLaDfiq4LS_t8-wbm9yQnEkScoxYO-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbXi3Avsic62fMdhLaDfiq4LS_t8-wbm9yQnEkScoxYO-g@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Stat-Signature: onshiebe1f7eph93yobe7kh7znno45cs
X-Rspam-User: 
X-Rspamd-Queue-Id: A76C84000E
X-Rspamd-Server: rspam04
X-HE-Tag: 1757344177-941632
X-HE-Meta: U2FsdGVkX19QxBjJJWemkEkNb3Uh1gLiUbp4hQKBOKqz53AdLCYPnAVfydZm8a2Z+jum3eqQ1Df9tSOW6b4NQIFXDZ2pUBVGJ9CyVjuc/5ZHUI5eLK3iMEc9PEdJqAKPpqim8kkedAnGBvBRkw8hV9iJNqZNHcUSfGk16HjZ4DageSWrQSwBY7DZsLUhzUnoN0zFvLDgXgkE6VOLWyTKcW1iakigawsELJTtnmI4b1twyVYq8jt5jGavPs+FBVqXrHM3hhWY7ROOgfiQoFSZ0HTIzxhxPHgqz4BER5E5RDCTI0lOrQ3RdvAjW+D4UktXVXl0pXqUgIAzNn54MUuWJbLIWO8wJ+vGzHB4fFCC863TL8Ha02FQQ0mVU8KqKTHQot2C3Fzryw6G+jRYnegmOte3KD/7Au37B4/oxBetRoRaRXJXt/qCaMSkMpEI4TCPLwIoUOWOa7lILaAzlPn5sYJSDydlbf+nFmQmcnJjNJUtY3Ut0x3TlAkEZiHMoL8vZhUqt4uJcsQDbudv37w59h2UzrcwAMis827fGMctmVQkrXSzdhOmX+eY6mM+RR3qmXqZoYXbCcLHZzBvltafVtByNgmH5dXbE7Zbytk6TuSAACZOe/OOArXHR25HQWasJ74GETmLsI+YbSmcjnUhoW0RiEN2XjngPx7+D9xlD3L38He3aqLb7K024wMtRVvWAl6qiR/G/9dVInzEfCGvYRq5gXmMTlkCWgt3TEhXgBG78H973tYM1htm/Fu1XhCpAhZoP0LG6ZNxJERFwi3Jg5+UM1/KKvmMoyjJLK1XDkFTDYGRkUS36gE9L26rUBwV4Xq4CQKC1y72EgJke2bQpzOdKbqiYBSaU6Xq3UCON0RVIwqf8GBYFV8mTqIIgvkbPPm5lPL+6UksElrD5c/Zy8XSr79ImqsNSWDs8+taboUqtIA4qM0Ruua9wVfJ3XV3PGTsg4mn/MW1yp5Vnei
 1kzFiQ5x
 saScqsdZn3M7Oc+v/TJivC41tgvoRFM6yOuWxRxbB4yeHqIrG0Jnu0SKA+w4g0ZPX4PxliL+nqOnAZG9D+FeJ2jZiVA2cgDdfcOYTYvN0C3TFI3hhdNvyMCkiu4R/8G+OeNXsoX/rO/dBn5vygg9ooWodQ3QGqjBhXrRKtHRzR2Vfyt4V4NTpAT9NtR566SitjG+caF0Kb76d0d6W3m1GWqn7EbtN0/90Id3v7aUX9i6D1H3NdExTQYPA+Ar3F0zi9jxa68gsgwUc895gDlnvB4IKmhWa6Yr4XgzFLCGzUiVkflbxPlgoWBcITCfjA1ApXy7n2EbcaLg1HrMsAN4T6rKoV4myhA1RmDj0UsPB4t7Qqr357cjBFrOpx6jLC1rvGHKkUIuNGCSxwIPvqhF6bogc55D4c/AmFXoNE53aun96t+TilU7lwu/Ytn4HYkDYgQtixflvRd1OuH4+9DlsxLpXEnR8bV+PrCK3Hb2tXlrqTWwC+8z3TQpIed8c+aT6fwDfTw9tDJdb762Q5O2T7KQlmCUUtIpq4e0HL6GMG+U63kDh4qFoom24Iw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/08/25 at 08:01am, Chris Li wrote:
> On Mon, Sep 8, 2025 at 5:36 AM Baoquan He <bhe@redhat.com> wrote:
> >
> > On 09/06/25 at 03:13am, Kairui Song wrote:
> > > From: Kairui Song <kasong@tencent.com>
> > >
> > > From: Chris Li <chrisl@kernel.org>
> >
> > 'From author <authorkernel.org>' can only be one person, and the co-author
> > should be specified by "Co-developed-by:" and "Signed-off-by:"?
> 
> That is the artifact of sending another person's patch in a series.
> The first "From" is from the email header sender. The second "from" is
> the real author of the patch. Just like an IP tunnel packet there is
> another inner IP packet wrapped in the outer IP packet.
> 
> I think that is all normal and did not violate the kernel rules. When
> I include Kairui's patch in my swap allocator series. The same thing
> happened there on Kairui's patch. In the end the git will know enough
> who is the real author, because those patches are  outputted by git
> anyway.

Hmm, maybe git doesn't work like that. I applied this patch via git am,
I got this on my local branch. The 2nd 'From' become part of commit log.

commit 337b3cd6c0ffad355df8851414e8aa5be052f4cb (HEAD -> kasan-v3)
Author: Kairui Song <kasong@tencent.com>
Date:   Sat Sep 6 03:13:43 2025 +0800

    docs/mm: add document for swap table
    
    From: Chris Li <chrisl@kernel.org>
    
    Swap table is the new swap cache.
    
    Signed-off-by: Chris Li <chrisl@kernel.org>
    Signed-off-by: Kairui Song <kasong@tencent.com>


