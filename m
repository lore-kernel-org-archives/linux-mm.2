Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FDC0D46C16
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 00:51:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB3876B0088; Wed, 28 Jan 2026 19:51:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B68F76B0089; Wed, 28 Jan 2026 19:51:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A756D6B008A; Wed, 28 Jan 2026 19:51:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9257E6B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 19:51:58 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 38F3C13BBF3
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 00:51:58 +0000 (UTC)
X-FDA: 84383174316.21.BEC3A5B
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf24.hostedemail.com (Postfix) with ESMTP id 45434180011
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 00:51:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mX6frHbt;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf24.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769647916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vFDSppbKY0RKNDPJ7Fa45/VD2FBPDC6HmmQ5Ho65y4Q=;
	b=tmqRGoXXWZO9psfLrm9Q1l6L0wFH7XAhqy2ix2shVXp7BAlJI2NsxjLOSdhzo1gxlevVuG
	fXK41E4n3ThYgK0s9UWosgo1CMJoLQLPUPGNxAc9wI1LOuUKJf6WaOgnr6bYrjKc6eiidJ
	osAn3toT5gM208qKi1awIBB2gdZXgVw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769647916; a=rsa-sha256;
	cv=pass;
	b=VSyYN8xt3UvC5M2m/cXDqrLNZwMlmTCigd0vTt0+mdVw9S4CNlIt2VFsDDL7U9aA/0Lg57
	xk8dlebdDCnQ2yMarCAhvGpHlXl4/Rp9oJeJfLlv0kxTPwk7sqJ5zLzmhC3l0UWseURtXK
	TjvCB8QAtOXaIyEEnuffjL4lcfuk5FA=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mX6frHbt;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf24.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-5028fb9d03bso3333161cf.3
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 16:51:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769647915; cv=none;
        d=google.com; s=arc-20240605;
        b=YKAM7YWM/KgoP/IUctlqHeh0prn2iHUFLcJoHKjdor3QvPeFsx+MOK1eTQW0o+HB6s
         FOuE9Q799Chag2FImvXhoiBFR7ZEH9uiCKN2r+WodRk2AyzOTtA2gyeJ9NtUERxmQ3By
         5facqVyH8125U8veWe6vXD6VbC53eIahn+xJlOzrJxnxys9F99/jAy/n7cy8m3hiY+26
         DxuEJ5njnT5GYCf3GqzMOhZT3UoDt9VA4yPBRueY8iFpCO/KYVllYiWs20Jao1W3x5vG
         Yj42rFbgjprTSNimbWbk9pt/z0MLes5V69HvG//1YlfhO3tE3EcLTFsu3eEPpOfoWbWK
         /4PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vFDSppbKY0RKNDPJ7Fa45/VD2FBPDC6HmmQ5Ho65y4Q=;
        fh=/oUq1VHolZIG5obdn+riZ0yfX17ha0FQ9kAFTO77ogI=;
        b=WQMjGZ+YGP+hDoJmWmPuxcv9HlhXrYg4aQz+JciwOZCJAqoKDZbYOTiWbaV2vncSo3
         e5wquhGRDfUCRG0g78DQahdMGDPKh55dR3fjB6YPvuQIMlkAYJ5NZlCOzicQWqnL1dfQ
         wSbYXzBQu6TtoWdmqjnQ449XH6PzOiCm96j6vU5/NBHQL3jD3h35WxxKSnO82pMJKj/D
         oyW//ydGTljszTMLNMFPx89Rcd2M3vgVKZ/KYy7wQFnMescB3S4Qj+WW1qrb0az1PJYQ
         O2PdbH6vEKCXr0WKKHr5hZ0Cl75d51AkJNQAVQys+rUXYczljAB4oN2kPWW/eccTRdUO
         Sgyg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769647915; x=1770252715; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vFDSppbKY0RKNDPJ7Fa45/VD2FBPDC6HmmQ5Ho65y4Q=;
        b=mX6frHbtRHz+RC+HwFKFkekr9CZ4Dl+6qxLntDRmCb+m8o/dVZLjurwNkimAjaNAxR
         nRvMWtSVOKxHpj/d+y5eOGS5fo8VpNaldvm5Q0Nx5XyMA8CXiCzNA9WnfcPpXCNByFX/
         XMdpIZdoubpme6Wo2Ycqal6CuBoc9LSGbwA5XoUL0p2w9Qws87HoP8L1rsZwu+6NZUrN
         q9YlPWOGw/kcZauxo+YjXr6TgNBmQ0vcFFszOhnyANLfAOH65BXeYNdf9GuDvA00McZs
         l8+giqhLmQAwa/mLuofqPNSloH+jrcd0xqCmA7uFQlEHzhviZ1WvKL+ONWs5NHG9xHrA
         CWow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769647915; x=1770252715;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vFDSppbKY0RKNDPJ7Fa45/VD2FBPDC6HmmQ5Ho65y4Q=;
        b=cfv1UqU7RwIhQ+uXuFF/N9kDKmDeh4jVmAZ4G1PHkFN9y1h10IOQTiiJokk2MpWE6c
         Z+ENHKLcAQ2X+5X/w/uNyZjfyhobVUt04hHCcktVuzP6PMaCt7iYJWUlhw6uLMDWGnMM
         cvwzPUXJaK3PWbidX/NEM2grfyo7t6p2pkjRnxtrLV4khDhVlVKAwpt+SGzR6mTq+f9T
         3qDq5bnMYFqGUbvcACMcEMqkBpdhHo0lvUL3FyjHHzZq+twlmxY3hrdVnRwrAYXDGr4R
         XcTVKlMWFPA+L7RVJK7sWLETYdBhRr9H3pGOvbGOroRIqEQP7XLonl/mrlGZkxwT53a3
         NZhg==
X-Forwarded-Encrypted: i=1; AJvYcCUUHqUvC20SDBVnYbtQyF3dCkxutipJarwP+hjwIzwdQjxabB+Xbx3mgr4xL29prScOVs7Zh+5eNA==@kvack.org
X-Gm-Message-State: AOJu0Yz4EKtgph3q4GBte39o6ibRDNJdnMWbUeYqP1N9WDyAtQte9LCa
	U5N6u5YT8a9P6X10gMB98ijtVP7Aw1DS2iNvKTtY06hvcAuF2rSA9WAfR14rSx1Yci53pdgmVUR
	mX02Zw77f65yulUuWjvHxTK5rB4lRXUo=
X-Gm-Gg: AZuq6aJBddjEfn3MOqLQlT9WSZjMi8icOAMdOseDrNGxG2IdyXLGDpJrwFed2iZJXXt
	gO9TG8LJhpsKNOfGWGRi3A1Nx664rg3jHv+jYAnXMKYtvKrIjdQufD95wEYw8H2NVnDhHayhkMt
	T96lWOC9mbCBKUcm/ZkgKqFzJjfubaEOdJy35VT8WcnkpHXeDgt8QfXffQUaFMTOXSHDTWptBLh
	7rvAO3X51jNqLiI20o3XEk55yEbdOethipGJlUNGEVBJsGN1hqVwXgiMh+uT+PGkeNYNs8N2UGy
	D1qvwlkxUjzQ5mWJaNdWDCVG9AA7YCVjbg==
X-Received: by 2002:a05:622a:14d2:b0:4ff:c884:31ad with SMTP id
 d75a77b69052e-5032fa0583bmr107426571cf.53.1769647915314; Wed, 28 Jan 2026
 16:51:55 -0800 (PST)
MIME-Version: 1.0
References: <20260113081453.8293-1-akinobu.mita@gmail.com> <20260113081453.8293-4-akinobu.mita@gmail.com>
 <aWZLZzo5Hb1aFZ0j@tiehlicka> <CAC5umyib=XmPkTvRT6eAsMx+WDx0NkSP9djh4xkhLJgwk_v8Mw@mail.gmail.com>
 <aWfXHKDzoQBsHxAp@gourry-fedora-PF4VCD3F> <CAC5umyg+wubKoQSfpDQvNh3K5Y7+iOEYn6_BuKFd53kHDVE7aw@mail.gmail.com>
 <CAC5umyjOgZE0Qpa3W3qZ=sSkwkuf_md47jctXgi5UKWuG49o1Q@mail.gmail.com>
 <aXJSlv1_K1uQCN16@gourry-fedora-PF4VCD3F> <CAC5umyhrcb963mA9dUaZswJKq2MF_OVaipNmy=L4J7u6rPjfqA@mail.gmail.com>
 <aXksUiwYGwad5JvC@gourry-fedora-PF4VCD3F>
In-Reply-To: <aXksUiwYGwad5JvC@gourry-fedora-PF4VCD3F>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Thu, 29 Jan 2026 09:51:44 +0900
X-Gm-Features: AZwV_QhRt-bXjIoQ8GFJDcYRtgG-C9XTXkZwe1eqV1SdIxAZqmC1j6C5xZLj-g4
Message-ID: <CAC5umyi6oW9qZZH75Owitojd+wgTGrz6uHsEFXxzo8aWF7FoKA@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] mm/vmscan: don't demote if there is not enough
 free memory in the lower memory tier
To: Gregory Price <gourry@gourry.net>
Cc: Michal Hocko <mhocko@suse.com>, linux-cxl@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	hannes@cmpxchg.org, david@kernel.org, zhengqi.arch@bytedance.com, 
	shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	bingjiao@google.com, jonathan.cameron@huawei.com, 
	pratyush.brahma@oss.qualcomm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 45434180011
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 1dmd7qd6waq35sy3mmzzrxw3wpp6dj6h
X-HE-Tag: 1769647916-70519
X-HE-Meta: U2FsdGVkX18oOHvPE0ngRSD6blXF3Vkv+uHrUz9xPEZhjZJcwdWJNT0NURSi/8ZFR2qfhZ3Y39BpteJVohlvKBoZyXoDFM7MZ4l+eyLPmwq9f0Muy5GvDkte8a99KQmFcuhTBCDCEyQDDZqpn9S69IxiJRGCrcRXbG9C9+8EO6Cic1zmN8pOb4BPSplCJDEMb41909Su/SVOVgivTJq0PQUCOcrRzdZIr8d419/Sv5Z+RsO+v+jSZrCvaV4UBe2T+j+VH2Db37n2sfLDXkl+JI/lg6xQ3sNz/MYo3AmCqmVJlrrC5oqxKqbY918ZWtQu284u95U/PLrg6bKK5ePPkDiqMHv+Q5jdVYwWvsbaLijPlPGPo5/KpxqY+UNvLj4JzoRyu7CAxY6Lla1JadvtNM5sX42haSPthayGT3emtM1IoPu+ofH+AFzxsV2mAFGs7lzEQY+GeKEl8ryozHKF2b2puLGgWgJISLTjNYaX6vuIvWkO87muVW2V+NnMp3zIdScLjRd02edmBiLK9Hn0TLLNSHkLeaJ5rdcE95l0w1v4IUDv2xJTYp9ixoh0ps8iEh742AupRRECU0JDSWth1ZSP97IQu4V0YORSEIIeT+//V0c8YJE/u7OdUeWFYHlPm6qZAF+sN+MblVibtcJWPv5eU6MDYiXtalkYrRim+jclVzhkzGfMk42jK1RDbBtEiXCp5zLPTqWerK5393erzQYmn4QEDgWgPIyHP0pTekbkNSCyMWuPruCxMltbPbLNpGcW/4ONvPHZJ/3FskBfZDmTafNhfMdXEl2eGVdfrCiCSkfPZC7psXYJBJf4l5BUGSHpuO65Ri6XOo6/aW1KlXOqRGiMQQKjwSSzBcIOIaqs7E3j8ZBzLTbhqaEICj2xa/r6DcVz3XbFkw8LUp5rhqOUzJmCQO165kJ7iNW0rD7BYzP8Dbx3JvhQWXqeUNJdhpt305eOqVIK1avcRaV
 wi/2DerA
 OAO4JRARUP8zrGHjJyCwsWDKllbYa0OTgDXSc9fdUd1sBLOpGLxZcTYKhSNrSQJM4lpVzdeTdIKYiPgvD+kn6y+ocbuYUGlL1/vsO1R7SYC4qzR2m05bhvXp+cRfEbGXexeEsPW8HAa7y5FLJZ3DwIi4K2ERsifykXwlnb7u1kv6MB49fE3QLMY7femMTDrAlD8q8X4z8rPBwdfVjXzoSyxza6Vlkx8gpa4wlz5X2h2VlhhcPR2zQfmaqnzAa7nmEzZGmO5LKedahkIxfUzH9yAJiuX9vz6pYtKmoyP2xO9BmBujI5xOXmAjHocV4KW2reHf/lL5xyITS06mBoO1ZUwbVOtHLj2a4fEa7OpG8740iAK/j7k5OGmUVkN2PSeTD7KKzNIdusDaLmA/t3E9cXwW332IS5ZV9NP9ibqifc+oGoSCIXao12XGO343AbX6QGJIjCA4UfYqhj+mDptP7rAIeSBOLitRZrgaIm2CnvDCMFL6Ctms5DUnf6W90xRDdQjqdrG09I+cHAYyAyAY7Xw8ifLJy0csg6VaYHsZaGmZh4zWuuj57oz4VW7mpj9uVx/kFSWg4AyK8q/VZ75GUqVijFw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2026=E5=B9=B41=E6=9C=8828=E6=97=A5(=E6=B0=B4) 6:21 Gregory Price <gourry@go=
urry.net>:
>
> On Mon, Jan 26, 2026 at 10:57:11AM +0900, Akinobu Mita wrote:
> > >
> > > Doesn't this suggest what I mentioned earlier?  If you don't demote w=
hen
> > > the target node is full, then you're removing a memory pressure signa=
l
> > > from the lower node and reclaim won't ever clean up the lower node to
> > > make room for future demotions.
> >
> > Thank you for your analysis.
> > Now I finally understand the concerns (though I'll need to learn more
> > to find a solution...)
> >
>
> Apologies - sorry for the multiple threads, i accidentally replied on v3
>
> It's taken me a while to detangle this, but what looks  like what might
> be happening is demote_folios is actually stealing all the potential
> candidates for swap for leaving reclaim with no forward progress and no
> OOM signal.
>
> 1) demotion is already not a reclaim signal, so forgive my prior
>    comments, i missed the masking of ~__GFP_RECLAIM
>
> 2) it appears we spend most of the time building the demotion list, but
>    then just abandon the list without having made progress later when
>    the demotion allocation target fails (w/ __THISNODE you don't get
>    OOM on allocation failure, we just continue)
>
> 3) i don't see hugetlb pages causing the GFP_RECLAIM override bug being
>    an issue in reclaim, because the page->lru is used for something else
>    in hugetlb pages (i.e. we shouldn't see hugetlb pages here)
>
> 4) skipping the entire demotion pass will shunt all this pressure to
>    swap instead (do_demote_pass =3D false -> so we swap instead).
>
>
> The risk here is that the OOM situation is temporary and some amount of
> memory from toptier gets shunting to swap while kswapd on other tiers
> makes progress.  This is effectively LRU inversion.
>
> Why swappiness affects behavior is likely because it changes how
> aggressively your lower-tier gets reclaimed, and therefore reduces the
> upper tier demotion failures until swap is already pressured.
>
> I'm not sure there's a best-option here, we may need additional input to
> determine what the least-worst option is.  Causing LRU inversion when
> all the nodes are pressured but swap is available is not preferable.

Would it be better if can_demote() returned false after checking that
there is no free swap space at all and that there is not enough free space
on the demote target node or its lower nodes?

can_demote()
{
        ...
        /* If demotion node isn't in the cgroup's mems_allowed, fall back *=
/
        if (mem_cgroup_node_allowed(memcg, demotion_nid)) {
                if (get_nr_swap_pages() > 0)
                        return true;
                do {
                        int z;
                        struct zone *zone;
                        struct pglist_data *pgdat =3D NODE_DATA(demotion_ni=
d);

                        for_each_managed_zone_pgdat(zone, pgdat, z,
MAX_NR_ZONES - 1) {
                                if (zone_watermark_ok(zone, 0,
min_wmark_pages(zone),
                                                      ZONE_MOVABLE, 0))
                                        return true;
                        }
                        demotion_nid =3D next_demotion_node(demotion_nid);
                } while (demotion_nid !=3D NUMA_NO_NODE);
        }
        return false;
}

