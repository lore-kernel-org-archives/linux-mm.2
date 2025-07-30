Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 749CFC87FCB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 20:19:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAB166B009C; Wed, 30 Jul 2025 16:19:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E83536B009D; Wed, 30 Jul 2025 16:19:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D995C6B009E; Wed, 30 Jul 2025 16:19:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C46456B009C
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 16:19:15 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5A5D958FE6
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 20:19:15 +0000 (UTC)
X-FDA: 83722045470.26.2E1F57C
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6EA3DC0007
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 20:19:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Zs93PJNl;
	spf=pass (imf22.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753906753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hVb487mVpeDozrUbu1+omY0eRgyQRi1HrzvWHnKCA5k=;
	b=xXd2U8uMMsKcDEKJxcyE+H85EyqdgtLXpq2cfQ4vQNb4FD/SSbifAzTkIROiR/O0eymA4t
	fH5h16ape5xBvSeqT0SkhUkB0if074Nvu9kCPrMTsgG1SXN6pK2buaXYSvvJcRkGGoVf/q
	KsAKkoubqqZ/8ZIz4lXqpicoxCuxzYg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753906753; a=rsa-sha256;
	cv=none;
	b=Wuu9nYWXYoCMdO5oRz/tTf6tK/yei1O4ME4TfRYgYbsdrI3bnLOJCYxfS6xgdTL+5bxzSj
	0bY+01s1FDDOyX/HEewX5ha5Ew1D3LRjqZ3t+t3UriNgg0rntYrhY19snBnT+yJreF34YZ
	ovWVUj1OJ+CZEWE3U7cyWcp3kAv0wno=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Zs93PJNl;
	spf=pass (imf22.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-71a206ec3a0so2378267b3.0
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 13:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753906752; x=1754511552; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hVb487mVpeDozrUbu1+omY0eRgyQRi1HrzvWHnKCA5k=;
        b=Zs93PJNlxu5D/9YdiychT1qgVs6kJwFiKnkprEZlWusKCTlyf4EI7kClEnWu1mGQLa
         D9inXTLKlxqfOVLp7ZlmejoxdZ+twLZjemMoBfwKqx9y6akBXufbV933ZP5i+mduv/Lb
         WLbwRXU4/MbAm2YW42P2uxi95VafXGjzIPWB86o4KQcJSKWxfYuij7mH1/jRFJ06bS+w
         yJRLD844IYmQVh1ha8qkRyBYzIeGMuovT+/hAA41oqcyeYZ7H5tVDo/8xGsqBQCFqyw/
         NCpuRnO1Fv6yDinvRzQmRHNw4wppPVNE/RmvBFfb6OVL2W3kfnR+3L+HEbxeUIHOIX6b
         hF/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753906752; x=1754511552;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hVb487mVpeDozrUbu1+omY0eRgyQRi1HrzvWHnKCA5k=;
        b=ddBJJZ4SKVFpoQn4dRCME/5GWb8W4NHFXTkMAZgVOZ9qTWG+hT/6q8QLq8f9SP8UTM
         XWU85TuY3/Gn9fehINXwUuiXFL0qyEDPyTrgCrgkfelwLjz4QKe/Br83FUdLQyk0u8Ho
         che1MP3mPw6GLd9ZBGCzDPI0A7LpC4sPAq2zJ7DFaHlT8fD2wuUQeBNcqGKFJeaYI8JJ
         kVLGrllNV0aiJjAHajbHpugecF2bM11Vj1nbd6tnlhPL6uLH01MQ1LYGtpEXkbFcvE7R
         IAQp1zYCZlbr2XObxo8ghQJHuDfqJfxdbH4nTKlTUmkAMHfS37RrvDJFP172oTfpLVat
         /lgA==
X-Forwarded-Encrypted: i=1; AJvYcCUe/a5whzqpW4zHRk/zw8q1SjzmXAyZMSfbcc/0WwEIKNRDlHCDF/OCXI1cdvjQehZfVGecOKYhYA==@kvack.org
X-Gm-Message-State: AOJu0Yx6mBJx8AfgmhynYcNaP0pcWLLf+Dq+vKtqzB3EvAAGeFSlZDNA
	HVIbmk8XEbIxdf2rLgIQR1kAX3liS7dGwX3oyCKKPVWYCG5Luld2i+D9
X-Gm-Gg: ASbGncvrjA32o4X12J6wJLij66uUGB4zOsD3vH10T4yTzCBBXVuN12CmfzeoRRXE/Eo
	O5og8/a9Yu9oQ1/hEfAhUaiffWOLJovNoYgrw0sA1YjPEGGNe16iBZf7pXUUVP6AXfbcVlm1pA8
	voh32mGp7yptxOeeB4RfTx5Q/Kwk4dp7/uVZTQV4jQbvPwpEkZ7A0RkwRN89GtLiF3WEiZR/Vb6
	lJ8z8wkzV3oIG9+wnbkyK15bGWfQtT43XarlHSckZe6Gk8K58k5QSOoSp4jrTLqXPZG/iszGYMZ
	dj7vDJpA7vqOW/pV8GZYrmrV0hQYwTlI6sJs5RfViSfsNzJJEuq3YNiuYw4fXRBNUUbYM2pJGXI
	seCIg+K4AIQkmXfBdbC6+Ww==
X-Google-Smtp-Source: AGHT+IEVHHeaxLepGJ4XhX4dQRHXkM7amOTdOXWWl0IJq+sKnNdeAJw8Mvta4DaJYaO2o1FBG0kF/w==
X-Received: by 2002:a05:690c:9a84:b0:71a:31cd:1848 with SMTP id 00721157ae682-71a475ca7c2mr54667467b3.14.1753906752217;
        Wed, 30 Jul 2025 13:19:12 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:45::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-719f2154b00sm25841457b3.9.2025.07.30.13.19.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jul 2025 13:19:11 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Alistair Popple <apopple@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH] mempolicy: Clarify what RECLAIM_ZONE means
Date: Wed, 30 Jul 2025 13:19:07 -0700
Message-ID: <20250730201908.2395933-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <87tt2v24om.fsf@DESKTOP-5N7EMDA>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6EA3DC0007
X-Stat-Signature: fxebzyddzqt5reingrph97pendah4iep
X-Rspam-User: 
X-HE-Tag: 1753906753-822669
X-HE-Meta: U2FsdGVkX18STkgnYSSUGAsnZfCtbzIJhgnIguVINYo/MvkCLHbJC9e9Ecj2VxfCLdvlhFktLoMq77jeAI2v32TzdaZICcmQEtcbEXDxdMkTMFDT58eozPduxjcfErfBsZKX21+LATzHaBNLijOLjKxpENQdLn6K7/72e7qpON5K+nKBVlP15K0viKjjJJId6nKLW2yCnxkI1+AWiU2xQ0Ncxor0TNXzbngkqbtE7wZrNT3W/vxhDMZy47xG5sG/npxkbixO91EuoXygUfc3cv8u29gNTJaqM/jTavV8snm+LUPKpme8OgJ//hJ2405mhxaukiNZSZyiH287o424peZ4/2gaMbu3KuAcnZ2o7hmkNpPRL3ptdD3FWNHzlKpQ/IKg5c82ji8qmvWrOz3agapLYNqzVz9bWpRgG+47s7j50qNaxj8qDNfjTrLe56hHsDISIml57PUMDDnKD1JGG1BrEQc9nuYV/ktlNTAgcNdCy2xPKS5UrnZ0FxpqVVWGBaZpEm/4N/21dZ/JqVIPDpbwEY+Gh1BwYJ4x0v/kRBdMG17G5Uy9YLkC3QwIPaAcCI3iAhd7hpzMKIVgbu8M4+nXqXjpRuDyhRZ+kAZLGmYGb4vNHnt49WFJIv8BcDVRTHqLSQ7oQU+5kpiTiZITu1Kb6gTBExnkdqBnva1+npfFmGHLIlsw3a1dA4OirzUU/IOWYpEYVwfJLps3wO4xu+xgTPsyEL/5MtRdwV3GpH2CMF67LV8ajo0tkqb0TOCHZ+veU7Hmzi3T61AbFer6eeR6XbFK6NNRBNvR+PgDDOi0jjBsR6dyBAfjIJzIGXKU3rYMvf1vjBqqleacO5HnZ4crSE/q+yFG1wue+9dSYq9IXjvPM9+7eorPOQCxwG2mNyrTlSkOW8LpDYa2T9PUzrThTItyJEX1VeXJnW6tUZGB160v+lmZSSbVi9n9rlVc4w0AkNpBDMlV8W/AlEW
 8zckb0xM
 0BZlQBa18hmUp0fACGireXTzdaQqvuWfKffP1SdwdI3aOjIvLfh6Gn9ZDI/J/KNWQp0zbKxr2gEG0esC8+S7levtw0a1jgjs/qkUxwZVOqe9K3IkbALHCXG4JJrnSu/Gwva0Sbjs55SjuUPoNDlkCii3Z74SNAa46s/4buUjzRhgEuJDJoESeuo9aCNlVYj63cdlTvuX8FknelaSqm1Ij4yCQOWYc1LieOKrUuSFwJE3rKGEKS71yGRiiExSXqHVZPrRHsmdbykyUiLHkG/p3H/mk+HEEt1Ot0Sl2IhNrjps+Ers54YZAYtljdk+4us3A9G76GT1IiXsbhDwzu14vrqkjpjlK4GLhNHfEJRZBuwQdB4Fapf+h+iFYI+U7hf8SAAuwJ9PWqUvLj6vCUqjSrh7LV1ra8yXrcreYgxlIq8AQ9JVCqXDkybdt4XOpBqv68AtbiyTCseeUkNnPToziUIdnCyq7oiSFUuhCM33x64ryb6mb2oyUwb+hg2jpjrwr8RsX8oGQ/g8kL93SjVkPzzeD1085I4w2VzN88fcsoyFNJYrEmEb4vQcKOIqU4rAPvRPkClSLlbYaj5p2E4UpZluSdw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 29 Jul 2025 08:58:49 +0800 "Huang, Ying" <ying.huang@linux.alibaba.com> wrote:

> Joshua Hahn <joshua.hahnjy@gmail.com> writes:
> 
> > On Mon, 28 Jul 2025 09:44:06 +0800 "Huang, Ying" <ying.huang@linux.alibaba.com> wrote:
> >
> >> Hi, Joshua,
> >> 
> >> Joshua Hahn <joshua.hahnjy@gmail.com> writes:
> >> 
> >> > The zone_reclaim_mode API controls reclaim behavior when a node runs out of
> >> > memory. Contrary to its user-facing name, it is internally referred to as
> >> > "node_reclaim_mode". This is slightly confusing but there is not much we can
> >> > do given that it has already been exposed to userspace (since at least 2.6).
> >> >
> >> > However, what we can do is to make sure the internal description of what the
> >> > bits inside zone_reclaim_mode aligns with what it does in practice.
> >> > Setting RECLAIM_ZONE does indeed run shrink_inactive_list, but a more holistic
> >> > description would be to explain that zone reclaim modulates whether page
> >> > allocation (and khugepaged collapsing) prefers reclaiming & attempting to
> >> > allocate locally or should fall back to the next node in the zonelist.
> >> >
> >> > Change the description to clarify what zone reclaim entails.
> >> >
> >> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> >> > ---
> >> >  include/uapi/linux/mempolicy.h | 2 +-
> >> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >> >
> >> > diff --git a/include/uapi/linux/mempolicy.h b/include/uapi/linux/mempolicy.h
> >> > index 1f9bb10d1a47..24083809d920 100644
> >> > --- a/include/uapi/linux/mempolicy.h
> >> > +++ b/include/uapi/linux/mempolicy.h
> >> > @@ -69,7 +69,7 @@ enum {
> >> >   * These bit locations are exposed in the vm.zone_reclaim_mode sysctl
> >> >   * ABI.  New bits are OK, but existing bits can never change.
> >> >   */
> >> > -#define RECLAIM_ZONE	(1<<0)	/* Run shrink_inactive_list on the zone */
> >> > +#define RECLAIM_ZONE	(1<<0)	/* Prefer reclaiming & allocating locally */
> >> >  #define RECLAIM_WRITE	(1<<1)	/* Writeout pages during reclaim */
> >> >  #define RECLAIM_UNMAP	(1<<2)	/* Unmap pages during reclaim */
> >> >  
> >> >
> >> > base-commit: 25fae0b93d1d7ddb25958bcb90c3c0e5e0e202bd
> >
> > Hi Ying, thanks for your review, as always!
> >
> >> Please consider the document of zone_reclaim_mode in
> >> Documentation/admin-guide/sysctl/vm.rst too.
> >
> > Yes, will do. Along with SJ's comment, I think that the information in the
> > admin-guide should be sufficient enough to explain what these bits do, so
> > I think my patch is not very necessary.
> >
> >> And, IIUC, RECLAIM_ZONE doesn't mean "locally" exactly.  It's legal to
> >> bind to some node other than "local node".
> >
> > You are correct, it seems you can also reclaim on non-local nodes once you
> > go further down in the zonelist. I think my intent with the new comment was just
> > to indicate a preference to reclaim and allocate on the *current* node, as
> > opposed to falling back to the next node in the zonelist.
> >
> > With that said, I think your comment along with SJ's feedback have gotten me
> > to understand that we proably don't need this change : -) 
> 
> TBH, I think that it's good to make some change to the comments.
> Because IMHO, the original comments are bound to some specific
> implementation details.  Some more general words may be better for the
> user space API description.

Hi Ying, sorry for the late reply.

I think that is a good point. Then maybe in that case, we can take SJ's comment
and leave information about both the implementation detail (i.e. that it will
perform shrink inactive_list on the zone), and that it will prefer this over
allocating on the next node as a general description of what happens?

On that note, one thing that I felt was slightly undercaptured in
Documentation/admin-guide is what "zone reclaim" actually means. What it does
is of course well captured by its name, but it misses the nuance of preferring
reclaim over fallback allocation.

Actually the whole motivation behind all of this conversation is because I saw
zone reclaim preventing allocation into a second node in a 2-NUMA node system
and was a bit confused until I understood what the implication of having
zone reclaim was.

Anyways, I can probably spin the patch to include information about what
zone reclaim is, in the comment block above the bits.

But please feel free to correct me if you feel that the descriptions available
in both the mempolicy.h uapi file or the Documentation/admin-guide is already
enough.

Thanks for the review as always, Ying. Have a great day!
Joshua

> ---
> Best Regards,
> Huang, Ying
> 

Sent using hkml (https://github.com/sjp38/hackermail)

