Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9C71606A884
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 20:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=HqvcA+a6
Received: by kanga.kvack.org (Postfix)
	id DC4E16B05B1; Fri, 13 Nov 2026 15:14:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D36616B05B3; Fri, 13 Nov 2026 15:14:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C27216B05B4; Fri, 13 Nov 2026 15:14:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 904306B05B1
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:14:28 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 23A571A0253
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:14:28 +0000 (UTC)
X-FDA: 85431198216.17.61ABE93
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3E0A14000E
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:14:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=HqvcA+a6;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794600866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IREpwUTT7bykH5+IUb0NspcAIFcgrOxudi44OIMVnbQ=;
	b=u3YtkGa32f6cR6BfZ5FA/EvEGR7JRYebqAbkE/pl2PWGzU02+3TdtZfffXqDKJvWlyrtKZ
	HW2XxHB8UEFb2/jl63ebIQv9iaT0GBuf5wqQ6UkTsM0tbMmLJm/EY/7JFpIHmyFHHcJgZx
	geX5Raok1ksC6TXzZPkfbBUhIpFxki0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=HqvcA+a6;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794600866;
	b=EXnruGMYVAI6npXqiBTkPNb9UXG3PpD2xmIGTqbeswGOeiGq9fVOqwvLoAO2QcSLs4ansU
	aepRG/TyOxZnwHO27BtLfQl/OJh8+UQ4GwYgkyeQi1N78935v8O+RdfkMZPcR0t7DiYYoy
	lYwNU1YFdCLno3Q/+ggA6/FFiNonS2Q=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-55c35262674so1586591cf.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:14:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794600865; x=1795205665; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=IREpwUTT7bykH5+IUb0NspcAIFcgrOxudi44OIMVnbQ=;
        b=HqvcA+a62/q+7hLKfU83VnR/1NPmntTEIqffoLKF4aozYrGDcnyY8qcbFNInVCQDfa
         6UbIcY2/AcfiOHSf1eevGMNgDNwE2pEeneb1oi4YnZsovnDUiCyGcFZ6xMBBJaCvRwA8
         8yb9CRn9HjFcOHmpeTG+e7bgq6VvcHIZqOUuYD3BSK2JdQicqtRDPQVsC4OdnC9s4pnH
         NqFN+DCVju3gOQFseYHpCu0a9HIEglXvI86z1WX/rjvk9SJHinIdfGNYsXGutbqvE6Vj
         1wZx/OPChy56zlr9hXMjfS9UHz7hzcZCRte7+8g1BRhv9/Q6ILgW95lsQ6DxHxf9Rqt6
         vL5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794600865; x=1795205665;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IREpwUTT7bykH5+IUb0NspcAIFcgrOxudi44OIMVnbQ=;
        b=jaTI0QK4U/C5PQ9Rq5OyXp4+wFhdCkxI/0WhBw5h8mf/dm/0OYP2+ncdKMMDgyeZK/
         CQIaBR7Cf5Y58SVaiglEjE3WKFtmDuAt/hM1NFPbbpC1atJ7tVqRBsU+DCphlPsSO0Ut
         pEDQu9k7iUxi3s6MSrWMMMrp8JwDMhH4TW1qdh7eqFLsPHB5hgBtE3IRWrAwGjYoYRBT
         q7dn8EOcJUoyp+BpVDzaua+wZvt8d4E77seyQEU4S78fM0H/CJ8risU9pH/N51/8AY1x
         dT9fYsQH0z9cr2pCNt+/8ZG6FrBCdRzP7lWgc8jQW++GJktvBFObJaP+FXGySDe4kJVF
         oNsA==
X-Forwarded-Encrypted: i=1; AL+hErHPzEFyy+N9biGhHdBvxCVDtz0eU9PUI4fickpFD1SWXf3bjVkBxZDDjcV+wAauVEqULyshvcLIeg==@kvack.org
X-Gm-Message-State: APuU4Z/5oZSYRvGehuZQrJwrWQJTQ526hr50iF+gw5hHHo9z+P+KdBUW
	3Wln7jXxfCOMgvVD7ua1sApIMYoOTnG8qBas7Bs12Qy/W9UqfkE73huz4vc9qWLqhhc=
X-Gm-Gg: AYBFou145oer5alIfyKaAp1UWgoyBuTV2TFPSxhtGpOtveATCUvvSwaYRQxa6EkUJdh
	3zvubHC8lUlA0EJY8gVfCowzS4JMzcL/Irurk2HDNZqygm/bEsvxLdase42YNNuQxSovHEU0kKp
	cQViiCYycNaK74Z8fz5oJTwMUb5Ugpn06G9xJ4kNfMDtJTJYjTwqH/Y3r1+4tJeRsZrWOzhJas+
	QBWSdNebXu/oWrFahY1Jt3r8VoGfqOie1/MLGriMWDGTu1znFIFcS162xlZR/dYQDZXCyXAQQso
	Xal8bKgX2TxXle4uSVluIVpzsp9zCgEwZad7ceokh+eTyFSlugHNcjMvqorv5ALUQ20j2FaPCTv
	THGnT9AWaR9RsgUyI5Ix0XBW9zU5SSRBOjRVBAy0zvBVUTn+jjwCK/bju+QWKaepmjOs5C+TNfS
	vWWMWWnU8Azvf8h/piEcIScQapHbszAqwWIUD+bLx5+lfmVvm85SCzKymR4Fn0m2flbYYVNDtYG
	twDtclvdR8eSpe9VLiRRRaQCjG10PbiHWmyAqj2Nf5OOa7qQs89E9tkxEzqJqbpbEb6RsYD6TRL
	fJnf+T/kdBFQDKE1JvRIlrmUQARaS1s3KbeFsgUx1DrtGDrkIOh9Vb/sav2NfMKCBUQNZ+v7XNE
	ONsB2TXFDow8fbioAwQY1O9xawMSHvQ==
X-Received: by 2002:a05:622a:4cc6:b0:535:a5fa:ee02 with SMTP id d75a77b69052e-55ac9e5bae5mr51686311cf.66.1794600865181;
        Fri, 13 Nov 2026 12:14:25 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55ad0a231d1sm25865101cf.15.2026.11.13.12.14.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 12:14:24 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mm/mempolicy: ignore a bind policy whose nodes have no
 memory
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Zi Yan <ziy@nvidia.com>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 akpm@linux-foundation.org, david@kernel.org, joshua.hahnjy@gmail.com, 
 rakie.kim@sk.com, ying.huang@linux.alibaba.com
In-Reply-To: <D1684A69-FC68-45E4-8349-9D5E5A327053@nvidia.com>
References: <20261113192642.2618878-1-gourry@gourry.net>
 <D1684A69-FC68-45E4-8349-9D5E5A327053@nvidia.com>
Date: Fri, 13 Nov 2026 15:14:23 -0500
Message-Id: <179460086396.482102.9206100238305098014.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: zyqz8huxb8c1gwi5dz3uq3rn3dd5wcfw
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 3E0A14000E
X-HE-Tag: 1794600866-463026
X-HE-Meta: U2FsdGVkX1+ARyH6Smz9LqZfNtFFwAqYtORk2CNEXuD+nTxo+ytQDTNORc2ykwaZl2ZHUhkXq3zgpQUJXRtPCDaK2tV7YHGjwIEabxuUVgvGwkgmgF4pg6uNRX6F2VMBs7dMGaCAfR+xwyHqR5PMAmrUVARztEnFhh2gb2ZTC9OLiBgehmdkbYEHWRDG6AKR9FjncFMUv8jdg+QbJLBOTdCvtR319Uv014xSgo9bJbD/teKCemmFrf1zTIAWBekaM4gOH+7GgArQlJH4Mx/gflixOnQ+qLUXUTUxRoBZJHoFdMQoET8GXDQc1DAuS7ef9Pz2Vm3r/vV7R+1UlBLTeg6t68PsHm09nw0CvEbPyusW1veRFs0xZ0oYodE98rdbMZ+t3Eff0ng1z4SaZSkkaYWpGkRQ8H5z/up0K65j75HjhkIMkIilti6ruzZsYKrGVhSC61A1lvhgjhCVvVSM//LoB7g5Sg/ICmicDjs9fUOFkA1nLQhzT8dDuFIk+nLdITWPEFAspa+3jGbbPA7FH3izp9PpbzVSfA6KuBdB4k57Qu3iW7bQ6/4Izqkq4qw641hOx8xcFp0MlFxqn3V+V+DHBLc3aa1fergpAdN+zIW9JGQUrkCC/0uBHOVzxUvs8pUkAWSKYWYPKcQGxjZSo504pzhV1buhwfnnYrWRggCSaWy7FWF3xKCpNg/hG7TBBX9UCXC/25MkDpQFAk5OEt2IjT0ZDKY8w7PS6pfhzrbfuTKlX8s+QJebOWkPzd/t1o3Ri8fWX0poUyMuZZyeaPq124PGpbcm0/UoPM6ttELdPHZVPLDWUNtHJujjQslbqQ1uHCyUT/5xO4La0TxqZc5jdHn09aJiG7zhkcmqUsr1bxIjsxHjRHzvDNBiNCb61QmFSFlEGatMjhiBzaNkmcQiuGKeIizmmZ87egvbiWo8FEit0xMLSF42Caz36+CczvKaO1vIe6uklmzxHtb
 KHfHV+My
 HJUWeRybZD9jvPcYObHY3YBhHol/yRkbbAsjrNYOl0eO+1bqXtNAiEA2HewZPHMYj0VGAHuguQWlKlIJXtew1AYUyRo4DzbcdNa1Fl+f6O4w0LL3/sN3hJXU8VKcXz9yhVN0/W0CIhyKNol/s42dkVj+Jbn9k7AALdEMlxp4hP1rqmEYwID6JF/1xxo0C2asp6b5qOQjV4Rx0u/XMR84TCgaRfQjKf077WVS0RoPHEYY2AydlwhjJj12Gm63NXv4HF89E+DhF9rN56tuy/LgcjqbmLtKXOzA4m3A/7MSsQrwp7C00JbI/gIo+EwPtNDi2/ltMKjW+ujfVxZQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-13 14:47 -0500, Zi Yan wrote:
> On 13 Nov 2026, at 14:26, Gregory Price (Meta) wrote:
> 
> > apply_policy_zone() assumes that policy->nodes intersects N_MEMORY, so
> > it reads a bind policy with no N_HIGH_MEMORY node as movable-only.
> >
> > On systems with CONFIG_CPUSETS=n, nothing rebinds policies when memory
> > is removed, so offlining all memory on the nodes a bind policy names
> > leaves it with none. The policy is then treated as movable-only, and
> > movable allocations are restricted to nodes without memory.
> >
> > This results in allocations failures, a VM_FAULT_OOM leak, and then
> > an infinitely retrying fault that hangs the process.
> >
> >   page allocation failure: order:0, mode:0x140dca ... nodemask=2
> >   Huh VM_FAULT_OOM leaked out to the #PF handler. Retrying PF
> >
> > Ignore a bind policy whose nodes have no memory. policy_nodemask()
> > already ignores a bind policy that does not intersect the cpuset.
> > This covers hugetlb's policy_mbind_nodemask() as well.
> >
> > If the nodes regain memory, the policy applies again.
> >
> > CPUSETS=n with HOTREMOVE=y is unlikely a common configuration, so this
> > isn't marked for stable.
> 
> Also no Fixes?
>

It wasn't quite obvious what to tag exactly.  Since I don't think it's
worth backporting, wasn't sure I should bother spending time on the
Fixes tag.

-- 
~Gregory


