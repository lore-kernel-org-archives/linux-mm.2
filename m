Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65083606A31D
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 16:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=c2N1f4ak
Received: by kanga.kvack.org (Postfix)
	id 382FB6B02F9; Mon, 19 Oct 2026 12:53:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 334B46B02FA; Mon, 19 Oct 2026 12:53:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 223696B02FB; Mon, 19 Oct 2026 12:53:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E71BF6B02F9
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:53:15 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6619E8077C
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 16:53:15 +0000 (UTC)
X-FDA: 85339971150.06.104D1FD
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf18.hostedemail.com (Postfix) with ESMTP id 84AA11C000E
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 16:53:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=c2N1f4ak;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792428793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xyTvuDZR4vVjsu5EkFdRLe73DiEeLvv3Sxajh/2hgAw=;
	b=u0CiASSpGjtetn8qMaVkVLQXcdNFRsR/JrMaiAqRPK4QKE3XEsMtFv1A65pXTHsgfQXMwv
	VGtqdR6ACL4gi+X736KYmyc4G/fa35qIkTb0BTu9pRUFPh3085RCYWWVato+jJmHdZvQzA
	PtJkj1FptzPX6GMgDjS1pQrdls5qe7s=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=c2N1f4ak;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792428793;
	b=MUuOry+0pqg1ErHiOzpei2xwuvzyf+sft1iSJLSJJ3gj9YiEHV6jLo3BBxQQzAzDh1jUO/
	Mr69BHI06NXrT6esrd6xCV++I4ELZXY1fhS42E2EFf+UCEaDxfedwjr5HVjDZNuhAsGH+s
	fB0GqBSSYYs1/RS/7qN8ZtL+JDxDjww=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-91b55859245so35348246d6.0
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 09:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792428792; x=1793033592; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xyTvuDZR4vVjsu5EkFdRLe73DiEeLvv3Sxajh/2hgAw=;
        b=c2N1f4akby1GWAHylzR4ry7E6ru/o0v4ZDwJyYl+GQN+aQRFn17HdSs8LJAtZ7Cg4b
         RoPZMQZi5jlTUJEWcrAbMYw2rnAEEc/QXxsJ37ZCEgYjSPB0HnDLOKMyV4nmgWIhGAgc
         LeOb4nMeCNtX/R+TVUA8Gc7iQ2wYyl4Y5vARKtwdGs55FL7eAk5IZgLc3MEFG4JsmJwj
         NYgHLM3EuyXUJH279bro725OKCx5571N9DeADC4ugjqbzgv0rQXZ0dZe2a5zUcCqdgN4
         De4xALVbTXN/aHdcTTLAksF12XqE0JhjSqxvl+oQ4G/r6xh51Tw9I1DbjrICetue3XI7
         dY5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792428792; x=1793033592;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xyTvuDZR4vVjsu5EkFdRLe73DiEeLvv3Sxajh/2hgAw=;
        b=fd2HdllKBtV1+GHy7Jtp67b0ptfhV8n5IVQXQ4JmmP/f0e+RG5vF5V7zer1nHw8aZp
         EKhe8voQGLo4Qkrn+Dnmc+o6IK6I1KO3TQIypxouzjdVXGTsuGouQhq2ToNdmTCqltv7
         pqCsgi8XBFk1L/7/2DgtpNIo+MaBJw16KNMeMM0HJqy9g2PecShmx/oekhz6Ks9JHU68
         CHzFQTzuT1MdtIM3LnrQcw0qCaz1zK67ofvr0+F9aj6CQAgm8a9APEeg5KWnz1DCWiR4
         DAq6qMGVTRT4MGx8b8T4KFRUf+XWbWpd8FJHWK0U/QRrY52tJ70sxyRohbtY7v2ceZh9
         Ntog==
X-Gm-Message-State: AFq9FYIcj9Am1mnX53P0gJnS9bgtDpCzetyzSBNxPB6l5J/Rq4MbIaGC
	4EO4cOyEsmVlE7UpEAYx5QECmGxV8IEjH8VEyKtin760ZZM7bSUlcFffvE4B9L4eAG4=
X-Gm-Gg: AYBFou1OsHDbdTL1LxCy1vAjtmdAy4hCJ3DYcqRJKcWiTdc32HOpNgrNlis7eRkSFhx
	yRvL6zIr7D+w/HT/Umru4IQHd25P76eHVkYKiFQsK4NHja4wabb/YSVk5p4wJM1gVoyNDkZ4jw/
	KsoSICXsNDlAHliLGp0RAGyVSXFyLcNjVA5RA2WkgbVJmxNysBW0hOrQps0hXJ6H+9u5FbqE2OR
	CdNR357wcxC0185QkqyKQNi68JVvMbM9ckfQBlLHRrkRdpFeIZPylgT/XEJgewyn3tl/I2QX5Sf
	1MtWNzAJz9ZOQvdQoA6ipL2lE8dR5EiRd1JZMbsNNrDQrb7vvp89vFhS6Qbej95XXcXegsZ5J1Q
	e3EPd1BCu0782NOg31iufNRmyz9gew2vZunJ6GQnn+XdVYL8BZsJx4PqJ6DvrCGmA5rM/BL43mE
	4dGXkibe23ektjz6la5QoW6BonfQndHF2i7UhpgxmDOk5V3l6UaOICBsCU4g3dMjN8Mmqsb970k
	kA09Xq3crV004VCt2xQY5R8WhmL45HnZC0uoZvPoZYNGO/7Y9KMzzhJJtAKzef0VA==
X-Received: by 2002:a05:620a:7106:b0:93b:db80:e0cf with SMTP id af79cd13be357-93f29db7f0fmr1372869985a.60.1792428792624;
        Mon, 19 Oct 2026 09:53:12 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f4b0d7c74sm1529985a.35.2026.10.19.09.53.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 09:53:12 -0700 (PDT)
Date: Mon, 19 Oct 2026 12:53:10 -0400
From: Gregory Price <gourry@gourry.net>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, longman@redhat.com, ridong.chen@linux.dev, 
	tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, akpm@linux-foundation.org, 
	mgorman@suse.de
Subject: Re: [PATCH v2] cgroup/cpuset: use mems_allowed_seq when checking a
 policy nodemask
Message-ID: <atZKl0yVl5u624o1@gourry-fedora-PF4VCD3F>
References: <20261019162138.3271947-1-gourry@gourry.net>
 <805cfff2-1856-4b48-9afc-174a56405283@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <805cfff2-1856-4b48-9afc-174a56405283@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 84AA11C000E
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: kgeziidkypk5ynqtgoc8bjca9g41c5q3
X-HE-Tag: 1792428793-812444
X-HE-Meta: U2FsdGVkX19G0QI1jQLDu3t1FG7LwWRYmiGsASHn7qztgwDtHcPsXA4I1XVeEVo30Rhc8KmEXQLtxIu+5URUJaDTuGBv7auEruBCCvbz/YnDfOR6FusEz0Xr/7C5VqiJlrnTwKmQ4fo/ifd3vCvoum/AlEqGgnFIuvND/K8c1GH0bhG9ZQpl5fzCBBgSatCou41ra/66V8va8dXuFECHa5NuUlYh+Yh7ezIP1H+pUpbzcfi00o1nQQeb/1z7n1x06HkUZ/p45XrH2Ax1BU5SDjjLogGKGCy8Z4AcWxtbJVZhtCbSWqhLmd2D8k/C40R75fQYA/w3Vekoh7DousSzf/Fwp2yUIKcr7oOWcb5Kw4pOmHQ7mzHsx8AcMFqLaTge79EnGZAxQenl0mA7gfRpXQT1+ZJCQV8/WPirXdlME10UY53q4uIPwaN5bcHDXwX96Np0jPmhX0Ed1MBUzO26IQiPElo9yBFsG8gFOBFUrsArq561O12m62DLTk8+RW2SnO139avu0SuMjJNmIoZuIbFBntmHthWJ+Q+Ni9nFsePjrmyqaqSpxdV2snaUgy9Tg2XsuN2ONwL41swOGAMK0yzOgPHxODuwwEVXhvZfwjoqQnnNEEsnKK2kMvMrp5JNa4PMW49fYXfc7kHmnNafcqKXhXxD8KiL8Idvgcyzov0E+gh3djUfDoDEG72s4OUEuDiHql+3vcNuVNAJAcplV3zx6xTn/SqQHqOgyGHhdxBWJ1ho85E3opFqezOAuI24ySXrpRDNuK3CW5CWBm2IDH4dlHXSdLoU9f+eDtJe9oFhtXNkR9tR0HVdRYvkLzF+W+ojPbplwPdW5h4PYQ/TdxsX8A8TG9+89r7x98w+zmLPXS1fdAec5R4Fyud4qMo9Nwfi+/1a0pfM2uzA0LXa6OJALA4Fh7Ij0MQBpqtvj2lhTHbZJvIKAvOecozTM7Cb7jWvyVQDXO4ySTxgzNu
 59FzRWQ+
 KlnFN0cH6MGrSbl6fvFZlacWFzy8XkV9LCLXaFb3+epZr63E52JRJdEdSLK06zWm12Zz8jp5gTrIHx1KJ4HFMkMcUioicVSn0EBlcM3jwrFsCT4W48yiQnnvmgXZbPaX2csx72PsSZZ3rbnJ3DiNs5hf5U5olv2d1UpLiiabyvLQMz9hBx2DRzSXBv1wky2hhxDScqt0GTUlGSOzhiGn2GDdHyZCsniJk+a9icQdIACoL9xtnpoNrurPN02wN8k+dbOv8zLKUmMFk99oseohuTKF5gX1/SyqO7Gbi1bbHGMpdYiTBkJ0Frle0qofmJ4dS07fePfLxp8Y2vJkc71CKFSgG3E1qOFftEIl3jjEgdAsxN9yUEh5BWdmcq5VlQagC2hFR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 06:41:50PM +0200, Vlastimil Babka (SUSE) wrote:
> On 10/19/26 18:21, Gregory Price (Meta) wrote:
> > A cpuset update changes the task's mems_allowed and rebinds its
> > mempolicy in separate steps under mems_allowed_seq, but the check
> > reads both without it.  This can cause a spurious numa placement
> > miss under some cpuset/mempolicy combinations.
> > 
> > A reader that loads one mask before the update and the other after
> > it can see a spurious empty intersection and drop the nodemask.
> > 
> > For example, a task with cpuset.mems={0} and MPOL_BIND={0}.  If the
> > cpuset moves to mems={1,2}, the policy is rebound to {1}.
> > 
> > The allocator can race and compare the old mems_allowed {0} against
> > the new policy {1} - which will result in a dropped nodemask and a
> > misplaced allocation on node 2.
> 
> And since this can have only performance implications and not cause a
> functional issue, we don't need Cc: stable.
> 
> (unlike violating a __GFP_THISNODE allocation which could be quite bad and
> has happened in the past)
> 

Agreed.

~Gregory

