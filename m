Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBE06C98311
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 10:46:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2B456B0088; Thu, 24 Sep 2026 06:46:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DCD06B008A; Thu, 24 Sep 2026 06:46:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A48B6B008C; Thu, 24 Sep 2026 06:46:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 62C416B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:46:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E287D1202DA
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:46:22 +0000 (UTC)
X-FDA: 85248326604.09.98A1698
Received: from mail-ej2-f42.google.com (mail-ej2-f42.google.com [74.125.228.170])
	by imf16.hostedemail.com (Postfix) with ESMTP id C4901180002
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:46:20 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="J34oFs/E";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of k.shutemov@gmail.com designates 74.125.228.170 as permitted sender) smtp.mailfrom=k.shutemov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790246780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FcwnbNetS6ulda+gTiRcez+BFmf9QclUqZrzpT2HS3U=;
	b=RMXM359srZdgYUJMzmdgBs8+rKpuvRWdaM3pyOKv04tbOFNntUnBF5GtSpWfKbo3VWVTeH
	16ZHeUmawO+CqrfnmCNbmlFamkTNbtrx8RtF/Pxn6aIlrHOVl3Sy0eMpcwGzOei0NEM+5D
	tiRHAKJeJe854Q1ZValcLCBiRvfxsAo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="J34oFs/E";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of k.shutemov@gmail.com designates 74.125.228.170 as permitted sender) smtp.mailfrom=k.shutemov@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790246780;
	b=ur3TYlC3DVXaMAWMO7DjJnE0EGwhIjLzwZsrZj9oCVOj8P04zlkW5cZk3mgp7z6d0yvORV
	Z9rLyikKESjGvUDX1r5RfDCdjzgzdzXeMQDyCYm90pTiHQyjgWxatWldMuvdTyNa1tfYdr
	AJKWGsgZs+z3HG/bNEkKQysnNaTR1h8=
Received: by mail-ej2-f42.google.com with SMTP id a640c23a62f3a-c254f6c7a56so240549566b.1
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 03:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790246779; x=1790851579; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:feedback-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=FcwnbNetS6ulda+gTiRcez+BFmf9QclUqZrzpT2HS3U=;
        b=J34oFs/EE8RVju/zna8h7R1/2mjTB0W7iNvoWUqlxSiiNiYax4GLyEPyzTIIG4/dYl
         I+gUE4SlKsSrxmdVWWJlqSAEoUSp7HS3UmJDLCsZF62VZ72iio/CnbI0Cla8YAHalkni
         LtQVbTQZ1atTMLGcEVW11evMubSXZGFyrKa7zcQaz09vZqb479TxGKYMYjo5HKnjUKCw
         c8cyPJ9RlJZunR0N2EvDynkRNylzPBbQk0v00SpGOCcwd90cbvJE0I0I9UFhaYBK2jb4
         6jS7u5F1IHFJGuqnQFLBvV562FgpKcs0nsN1iBb0mFndsBcP6CAKAny09ajypF0OOBGH
         Sflw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790246779; x=1790851579;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:feedback-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FcwnbNetS6ulda+gTiRcez+BFmf9QclUqZrzpT2HS3U=;
        b=R77O0W7tUzeW0T/pS3mCklr8Cp90x9wOv3CUzkVdabLaWWTtXrlc7fQAGyu/ih5wYh
         5sqNmSkaydk8L+acqhnA8yEFl846UGBCFptmSr9ZOuLgtp4iufu/qGTm3qsbFFEGXKaO
         EYLQRcfPKhmAAcbgLavCWBmokPlgLsWbOj6uM2gXYJQb+FguOZiOwg472JCsKYV9ChNX
         ZA4er0js9kGPPobKnPQsEMn6+Z0YBSYCWrFKIXyGpWuld/BZ2tPx33ujOu1HgEyCWyES
         oU4/yD5w0vlRp/FnZfVZ8U8bQakmdNGV8H4T3mUlH+onf1eF7tcZDuLQVZdezW4HXAFP
         FkpQ==
X-Forwarded-Encrypted: i=1; AKwUvBxpNNH2fRJfagnGjmK3DIGacSqAJvHvFvFeGCtJbp7uaYiMpAyOwsdPV/ILtAcvDt2+xTPLKQ9NpQ==@kvack.org
X-Gm-Message-State: AFuF++mD1B8Kt4fFXLzRHyboFZmOX+rGAsGM9eCi1flsmA5SICN7GVvh
	TOzaiKvw15pEz2k1Ob2xShOcdlffdOGnS5eLB8nM9ovfueYdJk3/TZA3
X-Gm-Gg: AYBFou3oFhCfU2pV+tgLox51JTR/geiC4zFY7KSiN9/RQ0S86tanHrPY/1gQxi7PslK
	JvJsChfYWezrzIMCdj+Qok+p2l79sNAImtObZqi98E1M5ETW+H7oLOolrcaCghkFVkJXKyNhaae
	u/oLPtAvf87nj/aGe/sx7vJNYcuZLKYBezrd+9s+3rtkAo/ABFOlrX5NYi72fGU0Ua29WzGkMTm
	1NJGEXyv0iEx9P2DJEQOrcV+CDFrVgT8kHLuOMrDF8AM145YoK3y9gR/lsU5i1TDYBN7I7Eu1qT
	AgLN/6FNZ0RVBZPmq7azdEVUuZb0hPyHIWBsMNGPue1THvtkkPB83YcKZA0Ff8W6w6AF+lXnQ1U
	dff+Wn9+Tl/yIvglOWoLJqcKQmCMAObqa25Z1j3PqkHA1lPkUiDReMGViRkRRscGeVwz+fj39CT
	Vp4DBTUnkcRWZy8NfZ1a6OAiix/nUzibMHJtEl+bTab4EaCT5u9fmRunN+/3KoePf4QmngRSc7W
	gFtB3VyGV8BhR5ob1Hn4LwwMKK+/HdIIYmvzIlFFn9IQOu6QtScYydGYG1c
X-Received: by 2002:a17:907:e00b:20b0:c29:41d1:a0d5 with SMTP id a640c23a62f3a-c2ac52c1075mr87901466b.18.1790246779035;
        Thu, 24 Sep 2026 03:46:19 -0700 (PDT)
Received: from fauth-c1-smtp.messagingengine.com (fauth-c1-smtp.messagingengine.com. [204.75.18.200])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2aae5c5c4csm283656766b.18.2026.09.24.03.46.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 03:46:18 -0700 (PDT)
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id 3A77C198004A;
	Thu, 24 Sep 2026 06:46:10 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Thu, 24 Sep 2026 06:46:16 -0400
X-ME-Sender: <xms:cf-0arVgu635GU8W5oXma-sLXwWAwBD1u9S62C7zSYEPH3L4s01Nuw>
    <xme:cf-0amzYKbsfWyYGQQdLBTFdrpsXrafewNUiKHb-73RiWfk4OZqjZLMG2ArESgJOG
    vAaiFnCRxhJRhomRwr1q_g-tDZCSr8ALHam7egr98UJfYnL--cQSRBk>
X-ME-Received: <xmr:cf-0arDFM_gVAbPn0O0dLznIq0EIvH_0Q15S1kLkEUcqiJf6J8gxwtIuSrE>
X-ME-Proxy-Cause: dmFkZTGUsvC9QSiKYNuIPHnuaTqnwZezjmL5UGmbpczRDwqaVuV+W7EoNW2a28xiJXSy+L
    PbJmYVKzPfJt6xvzdJCY5vqEwgi2ZLQro2KTCiol2XABI9ABKYtxP8FBemQHFrNME0b6vl
    fYnQ+Wpi/2qzxY5N5wodWyH/2Iq+xOMMEdh1SSRV894hCtVqnLOIJaif633f2/rwHysp+z
    ePXKS6G49ln+oXdrB5yHB/kaqXADUHEzhzeGIF6Hox9ZDLCDUx1PgRj+pRXrSvBvz6ys9o
    kdf3JR0qz8ab8OD0lH/yMlAU6kFGfCx7xJDLz80/YPu66g3epj25j+EBBmtmFgArMPUPYc
    o87jPnfGQh/AeKIVeMiqFHLnAZakS57e4qHhWWUEbwHU6IH7Ft6Nl22oc5iO7pPLIkabR4
    Sf2JCohmvoXV12tj6Wm6jB0PQmPQ2uOclz9TLpDeySZFxNt9EOwhyA3eRCapdRNq+FSUU9
    5nlKz2qr6+i57KeuhZnvugZU9+SN46UQ8/8lnF/c/MjAygvD8w8D1jhMVa4tVfRXjIbTjy
    o2mXBbuPsY5HGCiH41J0owxE1SE0Bycm5RCbKQBK/AxVuX8Im4TuuCAgqaPIVsMu890ggf
    NeCI1Mf61zy+ZgtQ3QxVpD8KNuuIUDE8iDuiWKwkEIwHpX0cvMMveC/m2OeA
X-ME-Proxy: <xmx:cf-0aqiBXAHhUFfiD9DCvMqK9Bc9b5aY9T8HNSj8bzPe7H_5If0KyA>
    <xmx:cf-0ajXbgqdGqppAiI_DJhberRbF9Q0N9gRm37Snj5C1oxfk3Pfpjw>
    <xmx:cf-0asF663HiH-yv7O49kFRexxKWa-CSCG6nIbFgDaatPju2XSNHSw>
    <xmx:cf-0ahGU4LImYrQNoI1Ktfmu_kdV0X3r5LElVRlNMDkIY4hAC748og>
    <xmx:cf-0apuG876QKYZojKSovoBmFzW_zK75581V3OU159p5U4ecWTEcNCyA>
Feedback-ID: ifa9e4bbb:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 24 Sep 2026 06:46:08 -0400 (EDT)
Date: Thu, 24 Sep 2026 11:46:07 +0100
From: Kiryl Shutsemau <k.shutemov@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, David Rientjes <rientjes@google.com>,
 	Amit Shah <amit@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 	Aneesh Kumar <AneeshKumar.KizhakeVeetil@arm.com>,
 Christoph Lameter <christoph@gentwo.org>,
 	Dave Hansen <dave.hansen@intel.com>,
 Davidlohr Bueso <dave@stgolabs.net>, 	Hugh Dickins <hughd@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 	John Hubbard <jhubbard@nvidia.com>,
 Matthew Wilcox <willy@infradead.org>, 	Mel Gorman <mel.gorman@gmail.com>,
 Michal Hocko <mhocko@suse.com>, 	Mike Rapoport <mike.rapoport@gmail.com>,
 Peter Xu <peterx@redhat.com>, Raghavendra K T <rkodsara@amd.com>, 	"Rao,
 Bharata Bhasker" <bharata@amd.com>, Rik van Riel <riel@surriel.com>,
 	Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, 	Shivank Garg <shivankg@amd.com>,
 Sterling Alexander <stalexan@redhat.com>,
 	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, 	Yang Shi <shy828301@gmail.com>,
 Zi Yan <ziy@nvidia.com>, 	William Roche <william.roche@oracle.com>,
 linmiaohe@huawei.com, ljs@kernel.org, osalvador@kernel.org,
 	nao.horiguchi@gmail.com, tony.luck@intel.com,
 wangkefeng.wang@huawei.com, 	jane.chu@oracle.com, muchun.song@linux.dev,
 liam@infradead.org, shuah@kernel.org, 	boudewijn@delta-utec.com,
 linux-mm@kvack.org, Breno Leitao <leitao@debian.org>
Subject: Re: [Invitation] Linux MM Alignment Session on Hwpoison on Wednesday
Message-ID: <arT9TVHmM3WDjWnk@thinkstation>
References: <45af1b22-49d4-5d60-e7ad-14a1a33c8dc9@google.com>
 <arPElEV0zDhXrteb@thinkstation>
 <42221bdb-44f9-4c86-a572-1d1372026836@kernel.org>
 <arPdnxhX9VHnDx15@thinkstation>
 <ce6659a6-a658-4311-8c8d-193d309bf85b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce6659a6-a658-4311-8c8d-193d309bf85b@kernel.org>
X-Stat-Signature: yf17i6omtkb1nmjx7cnyde6irridsjde
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C4901180002
X-HE-Tag: 1790246780-649438
X-HE-Meta: U2FsdGVkX18dsj+lK4pKxeBtlGc9UlezrbeqqKet0xnl7fQpFSrBMxiw9wxIzAoVATTmJn6nTK35CvSlxDgo6lr6ys2ROsfZKCHem5yvq5Il/NDg5/GRaLqHbnilKbSlDTO0uB5B0Z9mXR0F+XIqs95BCIfH7eTFGAJElGjNHksLhl1z6Kn5pXIFDqtjuf6ggNpyTo8FrAE5NyFUJOGi4gwAllaU0TJWnj4KgmJ6a1Sqm2l70BG6TeZwa6NJKoW8NPp06LlhhO49i5Kw5xyxc2MXHukXgAmPjwVPwZY8Pu90fvxmyZ0K27wsgrFm2MXclOID/ZEsdW8X3EGYNffqBSG7ywMUgJdXAlQUcty/cJGLAaYvgqXbpLBA/eJK7xaWh57daxWwesHP7GlXGyORF+xkDJQMRUUDYt+4AD+r72m3iks4QEBP3/WHWHmfX+o3X9sQ5u1RuyRPPZbKYfEiLTRClSd7YCkN0okbTEl8YSmvdCX62paIVsqjp7Q8kUpdu0MNXyM/bh+is0dD5J+LKoCtzCVMQsdw8LExYVPmiFbxs3yhGRhJmMsB/ZJHHFiDdvcyjhA1CCEE9Qn8/1lCPfLM042b4jvvag7fwNkzq8zTFJcBPVl8xJulBnLc4cq2YMWYl/wl9R675FuM8ygLWug5pfbJ8MafkWbfVtql698/iUQFLHMZViGtYuHLlfDHer5vFjaDavlOMXzizEYpNdIjNAwobb7d6DY39Ltkgpno25x95GS9lg/zjXMg+irDQZFGXZAdn8qyETQ51XeXw6OCAhawS/Xj9KOEo94t877GnBYLkeLzu+K6tKOE0plQWtdWn62BLNRsu8dXFCMN6/DuOm1peN5Sstkri06m6lE/N4yqq1iQZqHgKBXDZhXmR9IueHsIqr4hz2OumlXpHCd3nBtF84xWf0SA9++y6yTCHzWPX7rzboRf9nyDRmg2yVaD9fOlzZ43Kleg/xr
 V596PM5d
 UWfxyxb5S9735dBDc+4U9wWpGVF9ui9BElmx0isUvbbrHexVs70RCN4H2XLMM7iCuQ85vdThlCSpEP+spoWDUitCEd3N/t8GgGkTzKcyiXFqrOyJS2/kyvbAmcP7wXU5eFfiYF3NJdRtFaLO36V6C6ANUF0xXssbt70NtnEaMzT/IKlSwFsIyVshKtwgHcdyOsMYJc4/b/8h3aojaSipHef4n/L/19Tz6/x0hPuOElOxzFGex5Y7rlgdDNEjdpFoiKYkn/2aU7LuV9EphVQ0DdZOfR4tccIkhzmkKO0a+D6OCGHu685X/Z40PHfOa52nAJHH8TWYY0UyywUV+5rkLz++1svuliiPfEEKVZOLlYw5PztZYw02qZb3fQ59kv+iBnFj3EqNT5QC60OB3JJ4UyLhuXt+VujoeT7Urq6pS8tmZepb6RHD5R/0euZ/NHW4SguuCfhLDpQieuzsLeUtlvh9mJKnAVpF3Xf72ZqUGUjVbbPq1qSiSIRk2L8BLaHv4IhLYqq880SY+72mDL5Y7ybUc9Y4Wl+G8C24eo7RC6WM2XTL6HVk1ejdURmt2Uh5XqMg7MB4jeInHttw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 10:32:29AM +0200, David Hildenbrand (Arm) wrote:
> On 9/23/26 16:36, Harry Yoo wrote:
> > On Wed, Sep 23, 2026 at 03:37:14PM +0200, David Hildenbrand (Arm) wrote:
> >> On 9/23/26 14:57, Harry Yoo wrote:
> >>>
> >>> [+Cc Breno]
> >>>
> >>> This might be worth some attention:
> >>>
> >>>   [PATCH v5 0/9] mm/memory-failure: keep hardware-poisoned pages out of the next kexec
> >>>   https://lore.kernel.org/linux-mm/20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org/
> >>>
> >>>   - The question: How best can we pass information about poisoned pages
> >>>     across kexec when the kernel accesses a poisoned page, panics and
> >>>     calls kexec, so that the next kernel avoids hitting the poisoned
> >>>     pages again?
> >>>
> >>>     One challenge here is introducing another source (a new EFI bitmap
> >>>     that represents poisoned memory, in addition to existing
> >>>     PG_hwpoison) of poisoned pages adds complexity and confusion.
> >>>
> >>>     David Hildenbrand suggested that we should simplify this as much
> >>>     as possible in a way that we don't have two sources of information
> >>>     w/ inconsistency between them and using memmap as the only source.
> >>>
> >>>     e.g.) By consuming the EFI bitmap only once when initializing
> >>>     memmap (to propagate poison information to not just free pages
> >>>     through __free_pages_core(), but to the all pages on memmap).
> >>>
> >>>     Another challenge here is that we don't have functionality
> >>>     to poison pages early in the boot process before memmap and buddy
> >>>     are ready. So any allocation before initializing them might still
> >>>     allocate poisoned pages.
> >>
> >> I've been thinking some more (and will reply in detail to the series), but I do
> >> wonder whether memblock should actually be thought about poisoned ranges and
> >> refuse to hand them out (reserved/allocated).
> > 
> > I believe this is what the patchset actually did in v2.
> > 
> > That way we'll have to either
> > 1) make any architecture that supports kexec select ARCH_KEEP_MEMBLOCK,
> > or 2) make kexec scan the bitmap when allocating the memory.
> 
> My naive design would be:
> 
> 1) Teach memblock early about poisoned memory ranges. Don't let it hand them out.

I suggested using a bitmap because ranges are not scalable. Some memory
failure modes generate errors repeated across the physical address space
(think of a column failure, for instance). It would produce too many
ranges to be viable.

We already consult a bitmap in memblock for unaccepted memory. We *can*
do the same for poisoned memory.

But I am not convinced it is needed for the initial implementation.
Memblock is a small portion of kernel allocations. If we step on broken
memory there, the machine is dead and requires repair. It can be
improved later if the rate is too high.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

