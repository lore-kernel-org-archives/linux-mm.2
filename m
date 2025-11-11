Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CEB1CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 04:07:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B66738E0006; Mon, 10 Nov 2025 23:07:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3F638E0002; Mon, 10 Nov 2025 23:07:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A54748E0006; Mon, 10 Nov 2025 23:07:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 959EB8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 23:07:53 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3495058937
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 04:07:53 +0000 (UTC)
X-FDA: 84096992826.03.E3950A6
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	by imf18.hostedemail.com (Postfix) with ESMTP id 64BCF1C0004
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 04:07:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uAjmEoRI;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of hughd@google.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762834071; a=rsa-sha256;
	cv=none;
	b=kKtDrYHE5pIqlCyYkxhMLyM0dwEikF+YqEGa08TG3gPNyuS81W//C4Gty+tvbWNG0PUVQH
	RNUq3RcNnKU0+9c9YQlOmQCJtEPe3B8uFJzYhpmrEA/U01xD+1vmUqnQxo5TNNc4kDXTsk
	Z+cS9lGK+AmoReLJvgcSaHhdVzUz5k8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uAjmEoRI;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of hughd@google.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762834071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tQtvX2XQ8t15gjBEKpXNNs3ZpjZjdksPbAQ0ahr9C3A=;
	b=ktGGQenH9q4MyeFeE25zEN/ArO7NoGmy634xOwcIjYpQn5D0+ry59D9vM7czE28gtVCVAU
	OTI5wtI0apjL1arQDAjC4QI3hNblNsd3hDGgke4wwtNbvfug5zKxykKC9nhm8omY0mGs8K
	WHS3e8VHDNM7wl4rQMW3SnSgS8mjWu0=
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-63f97c4eccaso3497110d50.2
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 20:07:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762834070; x=1763438870; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tQtvX2XQ8t15gjBEKpXNNs3ZpjZjdksPbAQ0ahr9C3A=;
        b=uAjmEoRI8mQX5YlWYxsGNrad3kPGRt/+yWliQm8Bx3zz5FrlICQDkEcDsqJhHUGAG6
         SoiibdCUl5yTwbotopBydXN7BwNiqsh8ggs5raqqLKaoErS99fvPb1Q+pkLCM5i5YKnb
         HbzPwA9+4LG4BkQWjT1Hu65ebxfvSGsQaOVe5YGgoOr4Cabr3AmZK+/NkoyMHsSMyYfj
         TM+WGKl93cKG9y4UNbxlxfY2dJahRy7vyP3XlDeOjlCQadDHEHycNAlPtY+DGcL/KVYK
         NkBJL/KPcajSYd/RRXoE4HedcYO+NzXwqNqeQOAfFI8IqOfBB1cJpXKu61EBpgRH66K2
         HiVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762834070; x=1763438870;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tQtvX2XQ8t15gjBEKpXNNs3ZpjZjdksPbAQ0ahr9C3A=;
        b=bztCSSJyw/2xmLNrzpUK0s01aMysNpE9/cRqCE+qm+v16aqdGpLSRv7eB7MJIIS5La
         l9eRepezQLNyeySfLPbdDjXsHHtnpSV/3uruLSRItNufVwnL/5Q7XmML740nVaF2XDyb
         UlqBq6AlqKzXwH/Pzeegv8ufYGPCaEre6Qoj0vs/SKDO60aoSRBehhOOxXv9PXM0enHe
         5aC2RIRSSQzar3T8xxYy2X6Rmq9TbWXAp2gsp37ylj42BwPhUq5mRes/8JP4OmXbz9v0
         blarqtPbKJqBUISDGhczFYwUs2Vrn74QErL2TSyqucee1i34t52EbuyNczbiCdojZ2TG
         /O5A==
X-Forwarded-Encrypted: i=1; AJvYcCXveMrFLJr1iqcMibM0gzRm68iqrTe7mvfp2oCL2nwFRxMlRL6o5EMuP6vZ+wTGPinv7firSwQz4w==@kvack.org
X-Gm-Message-State: AOJu0YxUF5R6jdiOzvcV3e+3f3A3PMb50A/v9svXibQf6+WJP2ig0wrb
	fi1YRgaEICVa5tKmybZZXGlgyuTSME9+zMSeZRLwp1KdOsUWk7mTs9RHTyogexZOnw==
X-Gm-Gg: ASbGnctA1v/DCNVCWA56i/ELXrqo90KmFrZCY+0ZVmS4AJXXPEr/ULmyuddHrn6t/W8
	ykkPgNj4vjAu3Rpqiu3Qd4M85HXKNa65Ktkdi4IKqPKxFkJq7LGlllayG1tWx7gTT1asClmn4lx
	qeh0Qobk6feU4vGT+x+Ij47LfjPdx139bbhWx664Pdpu4jsbKkvB7FvBaqbtTSV7omyboyA2LA4
	i2yMZlKpsptHvp3eYzz0VfhuxuoJo4ltRT2nATMYwwwvgWzwLnMQ3X7TGWdbzh1ExxpXSFXUEIM
	I8t4D2qmvuMONMwJP3/F9ZPfK1+uUAbguTFOuM3dzh8hi87sXQ+TGLWSl+rcRRb7fYHMfcrSo2z
	wvHmb5S6qRyFV1wt2rwm6E+2ZFMR5dAOFIV+faVqrAlnBKjsgntfxNqJ8bmXdiB3VsbDipwYn16
	pM2iuR2PtqPBGtx/psFrw5EttaIAYxZuydOYUSOe3MoQ2mygrlABMTa1J94Ghiq7cfzlbujPPZY
	BgJjVVD+w==
X-Google-Smtp-Source: AGHT+IHG/jZ//4QM4bUIX92EmnHpoMxramdxwXCxkW843uk4feMGQ0nNfJGMFAqbmmzMPaRjaD7rEg==
X-Received: by 2002:a05:690e:d47:b0:640:e6aa:b2bf with SMTP id 956f58d0204a3-640e6aab4e1mr5979840d50.43.1762834070176;
        Mon, 10 Nov 2025 20:07:50 -0800 (PST)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-640d2d68bf0sm3436465d50.11.2025.11.10.20.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 20:07:49 -0800 (PST)
Date: Mon, 10 Nov 2025 20:07:34 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
    Andrew Morton <akpm@linux-foundation.org>
cc: Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
    Christian Borntraeger <borntraeger@linux.ibm.com>, 
    Janosch Frank <frankja@linux.ibm.com>, 
    Claudio Imbrenda <imbrenda@linux.ibm.com>, 
    David Hildenbrand <david@redhat.com>, 
    Alexander Gordeev <agordeev@linux.ibm.com>, 
    Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
    Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
    Sven Schnelle <svens@linux.ibm.com>, Peter Xu <peterx@redhat.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, 
    Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
    Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
    Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, 
    Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
    Lance Yang <lance.yang@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Vlastimil Babka <vbabka@suse.cz>, 
    Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
    Michal Hocko <mhocko@suse.com>, Matthew Brost <matthew.brost@intel.com>, 
    Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
    Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
    Ying Huang <ying.huang@linux.alibaba.com>, 
    Alistair Popple <apopple@nvidia.com>, 
    Axel Rasmussen <axelrasmussen@google.com>, 
    Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
    Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
    Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
    SeongJae Park <sj@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
    Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
    Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
    Jann Horn <jannh@google.com>, Miaohe Lin <linmiaohe@huawei.com>, 
    Naoya Horiguchi <nao.horiguchi@gmail.com>, 
    Pedro Falcato <pfalcato@suse.de>, 
    Pasha Tatashin <pasha.tatashin@soleen.com>, 
    Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, 
    linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
    linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-mm@kvack.org, linux-arch@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH v2 00/16] mm: remove is_swap_[pte, pmd]() + non-swap
 entries, introduce leaf entries
In-Reply-To: <20251110162313.baee36f4815b3aeb3f12921e@linux-foundation.org>
Message-ID: <ba5d8603-4140-1678-b2d5-d49ab1a40fe0@google.com>
References: <cover.1762621567.git.lorenzo.stoakes@oracle.com> <CACePvbVq3kFtrue2smXRSZ86+EuNVf6q+awQnU-n7=Q4x7U9Lw@mail.gmail.com> <5b60f6e8-7eab-4518-808a-b34331662da5@lucifer.local> <CACePvbUvQu+So7OoUbJTMLODz8YDAOgWaM8A-RXFj2U_Qc-dng@mail.gmail.com>
 <3c0e9dd0-70ac-4588-813b-ffb24d40f067@lucifer.local> <c9e3ad0e-02ef-077c-c12c-f72057eb7817@google.com> <20251110162313.baee36f4815b3aeb3f12921e@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 64BCF1C0004
X-Stat-Signature: i9859nrm8xox3pu11145kinstwpa4gtn
X-HE-Tag: 1762834071-819112
X-HE-Meta: U2FsdGVkX18LIWwZM20yugtR64uwA0OU8NCfo1aOBau9RxBHPrQuxOFe+QqwOYqCFpPz/dUUkcDoWz/4FLEyzl7nHY4r9rlvBZBhSzyABK6sTAly1taAvEqVmHFKCJiQo/kjbSpqRG+/IP1TFiwhTgehd/9bUWJPT47bAHjixDtfFScsdFimciBjQ29/bQx/5HdA82l3bBl+rqVzK0FwV4gpUclSk40arSPF58wnb44sa+NohG4wEuINlrtQDvm+fH1nii/H5Zd7cNh0u75FMSOuIIRKhoYy5wPcI8PgZ7moDgn2jo58X0G57RX+A34xf3TPXjLTf6N93rFf3QoNYbKkJviCW3OiJ2dmncVs6YpCTDIB+1KPi7sJlmFHOn1VyO8r3BHYC0IZUucTT4FUBBxjgLNW6/7XHMMrNtGSk6wpQV/S8IXM0fHQsfGfSsOUpdtzh1TyjpALWXwXZizX/+yWLjE7uLS19PuAJQ5iuBgCAcCjlAJN5pbIbUpUlh2kR+1aOxQpVHdGiJPTPYb6eY4Jc+hyXeEORsdhGXWrEcE6GyLOBbOsyGBOzsFYJw+HGlH9Xct48T3nhwq469qV/EyXLa14ZWaTE9f/WefMV/I28X7RPUYT2nXqFFqqHGn48FNG230xbwwWPvjHor+GBkZDxG6HTv7aQC+MtPGYuvuFLEoFzJ8KhcEQTVct/eeW+R2YYg19WTV7kHoFkdMl/D98a47l6zrFPx9oHjWVC7wKwp3rHpgI9cxgJYmfYY3eF7/FVKOI08bGGvBcUMCnV+Cppi7zji8shDI1xUqhE2D6aVaHudiItMkyEGPhw7JvxhyBmV+xmPJ2BRwnL+wgDiVGEepQe8Fhwh+TMkgdQ26C0MM6fdhm3+q5PgW656FmBxmg303GjWturXnFX/x/wkK9KConIaHnV73hHZqlzA5lksTL0cFMKobqE+0vG4ED2DaJa38EnU/80xuZX4b
 0q3ONuVu
 Sv4pYyRXHKSdQ10TKtCJNYwjk2GdmX3r+SNqXn54gCrHaDb/cngySh4VfoSWNJD9cFf0HK4D0c5IdJI/lD6tDuJZF/9YWUHU9vXn5Bdu4oV5iysNy6rtsj/P3o1gpcI3b+Hh/xibu8/MwSzqIM6cHKwxIKcBv5COW9+y++vlLZwCWEIzGws/ofgxIaES9lIH7SAX5PHy45gdE8dDD3d1MKj0Lj4GIKqwIROz5JQ4336jy/awSnm18dB2R4ctYACIW93SNQPB/JY8JEedI5CWDgobtjem1LO/85u7HkASWDP6IES2aIUIoJQXyVWnZj94AFQmuPshItaCaEbUi7j1dq0BK0AkfS7wXLW2gBRhUwM8yca4FR0PQ27aEfqnzPMpn18u0hv8SfVcKEk8Ph6hk1yzvXhVpWeZ6h0/pJTGUXfN7OTFBC6NSVoTMG1/AP4Kd5iKOu0CDT+gHWAKQfN0bRlMnyw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 10 Nov 2025, Andrew Morton wrote:
> On Mon, 10 Nov 2025 15:38:55 -0800 (PST) Hugh Dickins <hughd@google.com> wrote:
> 
> > > I'm sorry but this is not a reasonable request. I am being as empathetic and
> > > kind as I can be here, but this series is proceeding without arbitrary delay.
> > > 
> > > I will do everything I can to accommodate any concerns or issues you may have
> > > here _within reason_ :)
> > 
> > But Lorenzo, have you even tested your series properly yet, with
> > swapping and folio migration and huge pages and tmpfs under load?
> > Please do.
> > 
> > I haven't had time to bisect yet, maybe there's nothing more needed
> > than a one-liner fix somewhere; but from my experience it is not yet
> > ready for inclusion in mm and next - it stops testing other folks' work.
> > 
> > I haven't tried today's v3, but from the cover letter of differences,
> > it didn't look like much of importance is fixed since v2: which
> > (after a profusion of "Bad swap offet entry 3ffffffffffff" messages,
> > not seen with v1, and probably not really serious) soon hits an Oops
> > or a BUG or something (as v1 did) - I don't have any logs or notes
> > to give yet, just forewarning before pursuing later in the day.
> > 
> > If you think v3 has fixed real crashes under load, please say so:
> > otherwise, I doubt it's worth Andrew hurrying to replace v2 by v3.
> 
> Oh.  Thanks.  I'll move the v3 series into mm-new for now.

Lorenzo, I can happily apologize: the v3 series in mm-everything-
2025-11-11-01-20 is a big improvement over v2 and v1, it is showing
none of the bad behaviours I saw with those.  I've not searched or
compared for what actually fixed those symptoms (though have now
spotted mails from Shivank and Kairui regarding 3ffffffffffff),
I'm content now to move on to unrelated work...

Thanks,
Hugh

