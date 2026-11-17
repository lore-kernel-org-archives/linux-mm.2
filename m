Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0A1A606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 13:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c3hLoxO5
Received: by kanga.kvack.org (Postfix)
	id DCA666B05B1; Tue, 17 Nov 2026 08:21:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7B5E6B05B2; Tue, 17 Nov 2026 08:21:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C91F46B05B4; Tue, 17 Nov 2026 08:21:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A96EA6B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:21:37 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3CC3F40413
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:21:37 +0000 (UTC)
X-FDA: 85444673034.21.132C92D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8ED0480002
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:21:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c3hLoxO5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794921695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zi8OAGVQukL/w4MsMi+hTnD2T6SHZKyI0yT1q7MBUxo=;
	b=Uk5ASp4j/LDxLsEVW5vB214bh16HG7/n3Ke4CNkrv4qnhYgjA1sdooHTJv+cmBANAZb8SP
	YI9hzJaJ0uYBnW0E4/PThhgmQpfMPcFd0s6DgTP4+ay5KRcuDNrBLn011DuyyYHF1ziWlL
	aequjM18HY9E7KX9C2Q+0fpB5C1THJ0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c3hLoxO5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794921695;
	b=WUwt4YuXLtpgvfhH3KvXLNYWMED35jsTWchAQAjejhyPhybAJNRVnOxr1dY3gNyZT+hei5
	QZWuLJRZSb+9yjVsZ/fom0IIg+IJ0UQTEnpV4mGdrXXv/omJuzbjuDgCHSLqYOvMO/oz3d
	qeAu9Jkwf82okPIcLuxZpeaUv2SUCF8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D12843EEA;
	Tue, 17 Nov 2026 13:21:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC3D1F000C4;
	Tue, 17 Nov 2026 13:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794921694;
	bh=Zi8OAGVQukL/w4MsMi+hTnD2T6SHZKyI0yT1q7MBUxo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=c3hLoxO5ZMuNEHZiJATEkpv8p+udzJFUOp2pu1gs8MW23Tyjvpd3D5du5cH0GIhSj
	 Bebp/aNm3kBkENkyreMiaaRbw5sq5B+odL+4I/OoYt/D+eq54cF1xVwOpr0ITYdl9T
	 vFQ8MCk7K2Rv4I4qO5gXK/vWG9ZjwMRyJKbFL/jvCR6LjxpncbNktpakZhu1sTJwB9
	 B3R1lCX99cdmrzSMZYqCxRqLSKToEIIMwr9qlspSLiulHVbGM36Uj6elUKrnV/i4i0
	 2tey4lBw3qiOmYs4BqUHA9ian1oPvcab/cuHfj8C6pFzjqrRVluLMZ02KuMLv4qJH8
	 tkdcJye7wDIGw==
Date: Tue, 17 Nov 2026 15:21:25 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>, Li Zhe <lizhe.67@bytedance.com>,
	Andrew Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	James Houghton <jthoughton@google.com>,
	Lance Yang <lance.yang@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: Re: [PATCH v2 04/14] mm/mm_init: factor out common struct page
 initialization
Message-ID: <avxU1Ypb6Vy4Sp4O@kernel.org>
References: <20261113033442.62970-1-songmuchun@bytedance.com>
 <20261113033442.62970-5-songmuchun@bytedance.com>
 <179482576829.2379196.2091312590305150578.b4-review@b4>
 <44fc03e4-a545-465b-a7f4-174be2038884@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <44fc03e4-a545-465b-a7f4-174be2038884@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8ED0480002
X-Stat-Signature: kiftagzmi349i3tkoyjty9jr8hcnhcys
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794921695-216677
X-HE-Meta: U2FsdGVkX1+/jrUSYeygKqMIBQAa1KIZCzyD5u0t4Gtiyz3Vgq+MPgg78AQLZfgT25q9OCk7S8gJJYXJIyq3+xfTNQK6C+KY/YrwQ02vtTp8XU24eXnpLEH8zmvWLW1Sze7DR8tsEsg8LY6svjSAFUXKG+g2/DouOOrjF6c9xg3Zbc5YiesbuimJsMnJEdN62gpJomeo/hS0GOAixFSvj2OGxBtMgiMAhBmhQwzt85zU+uX4WzathZZDpF1+k1462fXD2A/kfmAF4/1zRk0IQ+sEVcQposog2v8MLGf9LbaAvK87R0OItf4BqDA0nONUO/av3v11eEggOGyYScghKBAZjz4IefbAjsLOggW4r64gsKzMqqnsntyTvAwPQJP+TGHszy2DvpoyqtJ+sroth4AEZm1W6hL5FrmTzfEhTJNhV3v4tUKPHpe5anY8qfsfUczTcZaAt22CQwn414SAwjeNOdi1ZZwtT4LQcvoN6Vh9hHe0FZ9XN3A/v0IEbZ2j4zMZbOpvYDsvwKWEungCDGf49DOxGahLSWWDueqzPYN8kKXEC/Rk6U6At0cIF3SQ28i9pqcBjbIb1l5z6MGVJVhgQyLOIU6HdRhenuGZRhG9/0fMrmdhdXNZU0HGgNUcFuBA+nf6SloGGTcuIHahAJPmEpYuEy1a6pg2kxlDUnBXZrt+uqhX5BupjzxFPUooeN8W2vBAFrtFk+B2OX5T2sjpVm0M0qvxGlIIpQ5fHmzJuvTUu80/vz1iIQRTqILGuC/SlKqkY9bZP2AVClQ4R3myJVxz3BqnGwAcb2Kuw68VK2StQm9oDBc7v6/x4qVD63eqO0rdSFTcS5K/qglYHayVnhLEpxiExbLqt/vlugjIEM+jDnfcyA81nnougSve294B/Dy0M9Gp7s1uXOYN3redJxBepH29r/aRdhf7KVAWGJeMCPzPusYdB25pxuzFC+savw0E3i1Saw0oa5C
 sOhO/ZdF
 uDp9o9lqTZapC3OSLVK/IsFZ02vGiJgn4ep2+yaMPhiynHo5k11s1q01FtWin7mieTfxXP95y3ChM79TWdHMA3GaQqVu57A0D1xmjXr1q32hmxfef92FFGPRZzWG0PVmL5ktKSpD4FbP0vxJQECzMZuAWW51ExJ7/t1NMpT3CqqMz13T/6M9qwQe2zh9FsILZdvXda6bB6q/IgZ+FNtl6qUDzmHbnlwdQevq6ojEbi5cwIlwq7HbDcNoi49Kj9pHwCPSk65oYYwtJJoQc3xtPQQ/63jqkk5xeheinUbOecgAGtW9MKBS3Yp9JU64C3sfV6iAgyZwusWTvQnA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 11:13:42AM +0800, Muchun Song wrote:
> On 2026/11/16 18:42, Mike Rapoport wrote:
> 
> > >   	page_cpupid_reset_last(page);
> > >   	page_kasan_tag_reset(page);
> > > +	atomic_set(&page->_mapcount, -1);
> > > +#ifdef CONFIG_ZONE_DEVICE
> > > +	if (zone == ZONE_DEVICE)
> > > +		__SetPageReserved(page);
> > > +#endif
> > Can't we keep this in ZONE_DEVICE part?
> 
> We can. But I put it here because there are at least two places where
> we need to mark a ZONE_DEVICE page as reserved. Handling it in
> memmap_init_page_common is simpler — it reduces the number of places
> where we have to set reserved individually. Otherwise, we would need
> to explicitly set reserved in multiple places.
> 
> > 
> > If we can't, __init_single_page() sets PG_reserved for ZONE_DEVICE pages
> > and the
> > 
> > if (zone == ZONE_DEVICE)
> > 	__SetPageReserved(page);
> > 
> > in the MEMINIT_HOTPLUG part of memmap_init_range() becomes redundant.
> > 
> 
> Good catch. I think I could remove this redundancy next version if you
> think handing it in memmap_init_page_common is okay.

Let's keep the #ifdef, still better than duplication.
 
> Thanks,
> Muchun

-- 
Sincerely yours,
Mike.

