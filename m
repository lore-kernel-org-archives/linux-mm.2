Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BDDA606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 13:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=U02p6Jy8
Received: by kanga.kvack.org (Postfix)
	id 53F3C6B05B4; Fri, 30 Oct 2026 09:08:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 516F76B05B5; Fri, 30 Oct 2026 09:08:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 407386B05B6; Fri, 30 Oct 2026 09:08:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 126756B05B4
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 09:08:31 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 13B7BA8372
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 13:08:30 +0000 (UTC)
X-FDA: 85379321580.15.3DA4CB9
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf28.hostedemail.com (Postfix) with ESMTP id 30ED6C0012
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 13:08:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=U02p6Jy8;
	spf=pass (imf28.hostedemail.com: domain of olsajiri@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=olsajiri@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793365708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kB4uf8nJGXdNhGjVXXj1WN5zeX8NQXSMnWRQjF7RjY0=;
	b=GPt0KDex2M0CqRH0+GN5Zjxwq8XtMni387KgeDDxcjv7ShfWNtENS2EO0YGCz/lGP1qdP/
	hY2jqEJrGjt//DfC/LBc2puk8wQrmyUCzygbZdyWtdEQOJUnGVs/Y9k62sovHgfQN9k7Wi
	R6cRGtm3miQ5E36tVsIulTnM3JhUH84=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=U02p6Jy8;
	spf=pass (imf28.hostedemail.com: domain of olsajiri@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=olsajiri@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793365708;
	b=SWrwLFT4Cq/OwnJCcs1eSuew1fbIeN/KRk7me84jxP7G0houVUHBKMvA3iDDFdVcnebUp9
	y9IEJOpzOX1yFNGLaJkzQ2TT+aY4uwBDGfZnVWZ+dbyPkjqKuiXA71gkuuJrRXlyqY/nlh
	IZADGAvokHnm+JkrXLAkXRYcDNx3xXU=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48afcd7ba9bso486545f8f.3
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 06:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793365707; x=1793970507; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kB4uf8nJGXdNhGjVXXj1WN5zeX8NQXSMnWRQjF7RjY0=;
        b=U02p6Jy8FIDM6JgGIUXKUJgEkabCAOAB63X005HPXTjcp+VldkQwrKqTH3lmiXitG0
         sUP6sl52vk28HH5SJPQXpQv/gyEVu/HavFSQQ8fvCciVU/IB0x5DQLKx1USOBeo7YLaZ
         JpnDxoYlXc+5zAnQvH3sstOiXU94GPI4ZVwZDbjMMGNzvmgtPWyKoNe6G9p6QgiK2YWW
         krrFO3oGQxHS934gXRDyy1MDo1iZQyTFoA+/B/CsD63d7o/vS3AUmSM2OBv88N3mtw+k
         30x/GimojjDKEeGz5yfDYrqI7OPV5yXAbAklLtAhivAMugv1VP7ziaU7aEjxVs3dUS2N
         a6WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793365707; x=1793970507;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kB4uf8nJGXdNhGjVXXj1WN5zeX8NQXSMnWRQjF7RjY0=;
        b=b2ilflgRYCLYB3JSuCA/Rcf5aBoBKYY5/jLTS+f1HmpdMUFA1GGUK8uJ18ymjLy8hm
         ANuix1v+gyCYRdextJZ1Nk6qgAp8IQD+iNGGc3waaOdEvDSTZr/eE1Zuluzn3afovCL0
         pSL7KWOqkZszLQHdqQYyM84lyx1vp/kW/0HWe+xf95QQ402L9tw8/LKO5PYFrbN6N+li
         8w5/gdCaPTTx1Z4oiYPbgGiaCO2kW1IANLuIqMQjZmtdEH6/aDkw+oheG8pmLzKNaBVM
         Xy6iup81Ng5vF071KF6gTYtczOo+t3obkeXcIeB+iJMqmuaGGhg4Pla/4XtRkiVAG36i
         uT6w==
X-Forwarded-Encrypted: i=1; AKwUvBxJ4YgiOTmuq23HXrEUgEN/cxGnj7uOp9K5MaZbJBg4ZDvg8E2k13dvRTPHXCnn7u9+d/6U04gx9w==@kvack.org
X-Gm-Message-State: AFq9FYLfjunBgcDUuHjnogN5+JpFgop8tyfrsg4e21Lr2kdFktpzjWuC
	J9FrcMY8icJllq3EOV2IZZFv1voc+oQgZXzl7C2LaPVFaF7DN7gA5Zkq
X-Gm-Gg: AYBFou3KAhLUlUiSyMoPoWn7MY4fEAK09cp0g51sdEA8ZbK9H/i9bx4luRfsnPy+ndF
	dgmdKw0vDUJOMbLoq+eouURTiC3bejt2vNLm8/WeDWOgW06LanG2lns46q1hR2pHRY0JmBQB4nI
	siud05UaMq1A5JfZymVfCsUh9Pu/pqNA1oFksVJOtVpk85vhDiAEKhRNkAR11GXxkuSCcXq7u7Z
	O+hzGiUKE1OiBtbRq0kB8p2mPXHsEZllHesqbKvgIqGUB2/IyPx3nfvleHeCGKKq9c9Kdq7hNTJ
	ZxkIJwYC/R5oRbE0+tBps3MWxvSl4MvqI/zmM6pOvRhRHSLnfsvCX1cWDdd2BqBJTPHGZJxmAa+
	USvqblodqlo8c5UplptuA22oGSRG0H1yRaijh21Dw8muD3N+hbMzAUlYJ4oL5yDM19/dTjKJB+V
	X/uevZao1q+z5aVNYVFxKK8xrFoounEU3VPnWzKSJ+Iyumcllv5nRP65tKDj5uHib/OQiM8ekfv
	KNQtadD5cymWFoX6D7m4ns/YPAd4D/78IJn4G0etNaAB6qEHFxkmHR9Rvyefb1MWf3LP7CcdlsG
	EA==
X-Received: by 2002:a05:6000:2610:b0:48d:ee59:3a30 with SMTP id ffacd0b85a97d-48e6e303b07mr6143806f8f.22.1793365706685;
        Fri, 30 Oct 2026 06:08:26 -0700 (PDT)
Received: from krava ([2a02:8308:a00c:e200::25dc])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71a4d425sm3353735f8f.1.2026.10.30.06.08.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 06:08:26 -0700 (PDT)
From: Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date: Fri, 30 Oct 2026 14:08:24 +0100
To: bot+bpf-ci@kernel.org
Cc: ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org,
	linux-mm@kvack.org, andrii@kernel.org, eddyz87@gmail.com,
	memxor@gmail.com, ljs@kernel.org, john.fastabend@gmail.com,
	nierro92@gmail.com, martin.lau@kernel.org, yonghong.song@linux.dev,
	mason@kernel.org, ihor.solodrai@linux.dev
Subject: Re: [PATCH bpf-next 5/8] selftests/bpf: Test user memory mmap kfuncs
Message-ID: <auSWyJS1ORYApv28@krava>
References: <20261029212551.56964-6-jolsa@kernel.org>
 <18976b63cb396cdfaebc5c630c926d88544160ef2a4c034e8a290df2b428806e@mail.kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18976b63cb396cdfaebc5c630c926d88544160ef2a4c034e8a290df2b428806e@mail.kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 30ED6C0012
X-Stat-Signature: m1otc5z37hhke8acs36cahi6zdu9htju
X-Rspam-User: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793365708-424953
X-HE-Meta: U2FsdGVkX1+UnencZBK5cx0RmRCyOh5RpZn3M6/f3XZv3I+melzyLyboAZTgc0J8sJ1u43iT9GxcEXoo6NFJJ1/VtXeazMSAtYDykcySkifEnU0PvnGXGDZdyb4q8g4S3k9xR7ZfULeXluZgs5/qHJ4gtZf0fDu8m2bv6JCUQYKJp442PHZz34TalNir2kEFlpkI8vI/TA2eHuZ76AlR9nUl3VcQFtKdouV8wxZD/HQNfNyomSObYsL9j5utdx717wK3WJDCMDh3Mr3oRit8Opvnl/eUf33oHaAGuZJkKyhB7UWpjnuBK5+MMwMqFXhmrTp2+vL9Av8iJINVVa1rceV08ftODaa0Vc3FQaCFeh//CYBa7Ov2reW25Se/h4okLDv9TLHHB9LLl5cHWY0n1xbQm4OxK6Mn/BYv2GNBVNS96+j8yZGO8apzMyJnWTpCT+W8xXXNCXgLPocNpEaBFuWzvY7j3Tfgq4dC16bDAIZh7WuOM41NGST/9MFR5P060cJ6MTHAGXCoCiIly5kaTcnGZOUKpVXQBjrTQW8KM5mwyH8SHZnPiLmxx+eOrmTdwASWkO3SS7bUZliIuwsyJRV4ThOrBU35HZCRLQaTQ6mVJHg0L1OWSIjsVtLVwapkrSQxxc5HcaxEovErOAvLGvr7p2S063W1uAwaqYFd4vYDz0NKOrbv2TTrZekUHsEQoZl1AuNOLanHQEVu6AqAyX6eDMlfyElGBrQhVZBh02lQMweSafyzHWVtv7hnQZ7kRE0OZ5LQ5PM1ojGUC3LcycXlrciTkbJYK/c6aHYgevgZHoa5/6jCrc3xGD6mobVsxfgbDnNSajLQsZN3Frfpbm4SinoItwAlnit4xGWUbeEkzHDff9xCVwmmoDWgDft2w/cXffbaBxX9355m/GHLzWSOACFk1AeTN0UDIZGSNnuEG5cFAwNS4ZpqFOSxtRs2r7BoRGOAb62pbjPXFZL
 bdvgy9Od
 YmyjGsnz0f/ciUw8yXsREaZeB1Ol2fXNGlQ+T85uSXVAyUNPwVPS+bsuCZJAhF/wQGeQZGIP0sWOXoaecfES5qY2Fmrr8qJqI1yfrL64DBvAK7BHrAYAl1bqIMOJy/pqlvcvHRmjcRLjwkjV1cnR85zkfneMRYXg2GZmT/IOZk7JOFkm7J5NDtvC/ewliq+ppCjbRDakMDQYKtT38e0BK5a4srMNylTTNdRBahd7G+Sk8zg67VKVd2srLfjupszEsduDHAB0kWFmtiIcrs1rKP2svYOLboeUhvFPLPYSGFFA2zQO61zcwDP9OvPB9oZA9v7OZXc/CRdgNveXlFE/a2hQcWWKds/9GiXZgotwoXtl355N/OwT9xfdfj82eqeVPoxpBS4D0aOGB8KE0szMjYi+Mk58jmZ70rwvrqJl6CpTYK1DiOcSErrPwbv8cZoYL7+NM8gOeXbO4QW8gsDOZfE4uq/2QxMFV1PTAUclJzTmP01cr/oZxNFD0E6hv1lexOKYH0lMrjOgykCaXgsaOhmQHtERLUGUuQWTg+FUgcJ+O29S+aOZNeAFwiqwZtsfGhFXdRkkW4w2ZmhMrhxNfZJxzGpgt9a52xsmcT7xKaJgK78M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 09:59:31PM +0000, bot+bpf-ci@kernel.org wrote:
> > selftests/bpf: Test user memory mmap kfuncs
> 
> TL;DR: Nits only: the changelog omits the kfuncs.rst documentation added by
> the patch, which may belong in another patch; also an unneeded
> <sys/personality.h> include and a never-used NULL perms path in
> check_user_mem_vma().
> 
> >     selftests/bpf: Test user memory mmap kfuncs
> >
> >     Add BPF selftests for bpf_user_mmap and bpf_user_munmap from a
> >     sleepable uprobe. Check that created mappings have the requested
> >     permissions and that unmapped addresses are no longer mapped.
> >
> >     Assisted-by: Codex:GPT-6
> >     Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> 
> This isn't a bug, but the changelog only describes the new selftests, while
> the patch also adds a "4.4 User memory kfuncs" section to
> Documentation/bpf/kfuncs.rst.
> 
> That section documents bpf_copy_to_user() as well, which is not exercised by
> the tests added here, and it states that seccomp filters do not mediate the
> mappings made by these kfuncs.
> 
> Could the kfuncs.rst section go into "bpf: Add user memory kfuncs" or a
> separate documentation patch, or at least be mentioned in this changelog?

yes, it needs to go there, will fix

jirka

