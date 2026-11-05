Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34184606A337
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 18:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QFZZ+R+7
Received: by kanga.kvack.org (Postfix)
	id 4C6E56B05EC; Thu,  5 Nov 2026 13:44:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 477B56B05ED; Thu,  5 Nov 2026 13:44:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31A7E6B05EE; Thu,  5 Nov 2026 13:44:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 058D26B05EC
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:44:36 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 93F9B1409D6
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:44:36 +0000 (UTC)
X-FDA: 85401941352.25.21BB7FA
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf09.hostedemail.com (Postfix) with ESMTP id AD53914000B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:44:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=QFZZ+R+7;
	spf=pass (imf09.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793904274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R3MeO5bU9u9vZq0BWi1LFpN7YGyhm0gURVRh2ZqhZrE=;
	b=FlW53xl/NhliONDCieDwzAKccY+aAOkwZps4bSII0hjxMCcO5qfNTEhgG16DwSiDFJJyWN
	6KEWwAThGZV7WZMU2l/Qb8OlYcNM474Ou9q1n0197EF4iFusz4cpU0b+g4YtML23ItVsz2
	mvCieuQkeACWNQ+dbwecjGdCD/ZbDXM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793904274;
	b=C0DBwWCrQP0tnSnwdMpGOkEib//EcM8hHTUmCaheAW3aZi1C/cRyOvzt/RGb9YIPwYr85T
	PXiFizMKBUQ1niQT1feIznvy8yX0BPYC/YHbpVTPqA1MMxPukw+ubI3Wyt2nUDe1SeSIUi
	ADruWD2hY/WponcS392oDfOY78mwwhQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=QFZZ+R+7;
	spf=pass (imf09.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6b4bd3d98bfso2565689a12.1
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 10:44:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793904273; x=1794509073; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=R3MeO5bU9u9vZq0BWi1LFpN7YGyhm0gURVRh2ZqhZrE=;
        b=QFZZ+R+78gIayFeYnqbTJI7EqKZQS1PGpP94QQsRhJ8vN5uf4k2k+HPvaKseJJ/CaY
         rYl+HOHadfSa4ILUAoSzqHCq1+jcihCJscm+Z3LwH5NpbhoCu3G7O621cvzyWGGsBzQ7
         PHSFFF/qJ04DD/noEdnvSLbven1EJJLLGmVC6fBcn85uet8Zx/a2xP7QQ/ds6OH9ypg9
         x/hiUBwWVPJJhOiXTyvDTpngIj7zNQXjlCq1waoiJimDkmDNCPdIdFxqh8Mugl/K+ipC
         lzolpGZZxIGJqqHqkIThnprY1wFPWiscCFyzk/7D+utzKDxp0iAZH2ytW4XnY+JNv+Hz
         psEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793904273; x=1794509073;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R3MeO5bU9u9vZq0BWi1LFpN7YGyhm0gURVRh2ZqhZrE=;
        b=fti2+dPRn7z5RivHm518WqeHTd6IcjeXSvQaqyYxNUnn5mNTwk08VsvCCpneUyZucu
         6YIOo922gpsEglw1cTbnOnrhINulzV06r92GVx5ksPp09TKxm8J4mk/D4h+S7ldodJet
         +ppBXmi4pdhA3BHgS3/RMD92wdfR8KRIYkkTAWPCoeAiidXg5lOTeql2/I44uG1yf7Rb
         LPg1m+PndF6KmEnN+ignq32MEqmpx4b3dRsZ8NtWPGG9MaUvbVjVT/F9z2c+PUeAgPQo
         YhI4zlhdCkMWT8lhaLqX6VR6rOwzWYahf0p1pJ0R3t5HdUcjbJ1n5Q36ui5Ys5WRVFn7
         mICw==
X-Forwarded-Encrypted: i=1; AKwUvBwvzUYTzXiRQosyIKIFUyt8oS9Zp3Ou6rD0Nm558DC6bFcAnEWQ1ZkcvfRQLGxoetmBgqpLegPcAA==@kvack.org
X-Gm-Message-State: APuU4Z8d8KsepncKvW8BRcmoGXptZZGvIo7iwyY0y06zIRjvViLctt5H
	oKDHf03MNhHvdUmYg/BCEUZsIrFtvzHVqzCMD3MnUN6Pg5KKkd/T4PMR
X-Gm-Gg: AYBFou0GFZy8MAPR4fCtpHqJsVkKfj/Z4yQTmkzxclA/Yy1m/+Q43kCA4Unu70oF5Cm
	3x67IyRiWIBpBnfRKa9krzqifp36kpB8yin0Y3ELTFOR1sMlm/6jMAIjNFTG8Mb4wg8q/QMllGF
	3s0NI3L7M1cAZsS8CsU3xwYjflxPcr85KX7jd5UZ0CRHSNzb4L5Ly1HH6pb+lamyxIXCe/+tLRP
	r3CFT2F2khHAn+5891E0IrYoiojYeDCWSqIdveYpvbT2uZx5shr8MKHy58D0nONtUMzX2RrO5yu
	olZnGxJ+pp3g7ohg8NQPPB9a/H6biaai8UauVNL/MeBjn6F2mNqChtBqiAnP6vraY2PKjr+KtYJ
	TWoMnfK1Dpg/S9uxoilEcAwO3Ah/vGPJuHmbbAn1m5KQs+CWbfmGpXh/l7HiKvuANErXvKEY9Kz
	Z9LyAUMqNGc08dxK78OeWzGwvf3XIKOrZc9A13LmrZAcRz9Yrla0f3PtiBaYsU+AY1lRs6rjgNt
	AF1wT6Zx4ul+rysb3KCwnHVC8paJ1tEBvUEwFJGd7G5K8L4cPpSpi9s8bGluBZJBmnF
X-Received: by 2002:a17:907:d0f:b0:c48:a838:c188 with SMTP id a640c23a62f3a-c4d34c59db0mr39140466b.13.1793904272964;
        Thu, 05 Nov 2026 10:44:32 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4d354ac249sm8993666b.5.2026.11.05.10.44.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 10:44:32 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 5 Nov 2026 19:44:30 +0100
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Liam R. Howlett (Google)" <liam@infradead.org>,
	Davidlohr Bueso <dave@stgolabs.net>, Michal Hocko <mhocko@suse.com>,
	Baoquan He <bhe@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Graf <tgraf@suug.ch>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
	Lorenzo Stoakes <ljs@kernel.org>, Chris Mason <mason@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>, stable@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH 4/4] rhashtable: fix vmalloc() deadlock in atomic rehash
Message-ID: <auzOjphJ8DWpXwUy@milan>
References: <urkgmijyytg3rrislm5fdzmfggqavzpiry23f6lpkqonvy2tqx@d56stj3eixfa>
 <auaFhOa5EBz4gJwK@gondor.apana.org.au>
 <xdzcyoou73blpfdlgy47i2ktrcsffnclerzojpgrxphid54gjc@nicdcvzqx447>
 <auqtTjXhD8is-y9f@gondor.apana.org.au>
 <CAHk-=wiE0KG+jkhmJWifXuAVivtB63WCWtdEpGAex7-T0SHd2g@mail.gmail.com>
 <aurAxRpCwzeyXeVj@gondor.apana.org.au>
 <CAHk-=wgPvbYRcKpQ8WTH-EYZRgMG0KSH+cZxY5-Hyf+X7JjWsw@mail.gmail.com>
 <aurJZ81qnbiHH_P1@gondor.apana.org.au>
 <ausS3LQNkdc6lBy3@milan>
 <auxDm_YO4oACA_d2@gondor.apana.org.au>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auxDm_YO4oACA_d2@gondor.apana.org.au>
X-Stat-Signature: mgutpra134ucwwgag3kfuoxjcb9u533c
X-Rspamd-Queue-Id: AD53914000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793904274-323971
X-HE-Meta: U2FsdGVkX1/Hi/Oy1jKzl6DGROrGTxX6dE/9p/qGgttlrsxSD1T9H8zYLix4Icmjg+MC2PgdZ5r7RwLjol+jyYSx0ExK9AmF3sM+cLxOD1kc4sMPuCHkSSRB6LFCmXEIxvDnxS6N89cisK5u+tHHV4S5uGL6yjjhMwQoToHjhRrhIbQuvic7nI2l27mT8A4T4gpxzSTh61Z/l0PFNq9faOdC/iMK9FKRspXL5U3Nvg3FvS+PNRf4QVNkcDN8PGTLrvcSWf34oVAGgFYxRlxQkgJrwSqDBL6XgkWnS84tCLbfFOVRHniclvzIXWv3nU2ENP3sMlij/NN6Ulo8PfbBLbOTIYtXhXAUpb3BwQ+FkqlhTSksJ/j23ouKnS+7kK880c18k8jKKeIpwCCU6PSAw8sv3U3kAdFlYkhGDkd0cRtQmqputIU208wyf+QbrTv2HT1za+1lnCQTg712yu4nEyhK/kuB2eVVvHyvAW5KyXWCfNCFOl+idY/8NEJ8nA1E+SQZmPNPJye6B+fepoeI5oNrLtzsltM+x+0nxlkSmRGdzo8oEtHWujiGeCQYcD7fQhPV+JrUKSDQOCwWSANWVOCTkZeC83kDE0kke9JQ3YBfQa34+bptJWiWwXV47SqjGvZyLaYYQ01usGwzcAO9SA+G58djmhFCqavJsEz3ooH7mlSLEzlIBzuSSho/jIuApSfcxmZO6qEngTNmFNEcW58KrPKbBj69YjL3lJDZC24Aqo/YW1iDqbw5GrKBCmnwaTzeKsJ+kyiTCWueAxGS1HYuga2lEpGHypXcNwr+Bp3EJvOBLMcQI9BNkjM3zkgTn54ewbIri4LnxsDr2AoCoOzWWm00A/jzG5csrvVa34oEUZjTzyDkfInHo7uRjfsta6A8MTkTausFzeYnGFQQHfe0KXe4PPalzzC2TqcoHLszVkgyVmN2ntUs3tnNcYMfvkJIpIQ328RAtwHQ4Ph
 CeBGBhVO
 8JNQtElsmsu9OTSQPiLCgwGQhAk8pb2vo1nOWx/OU5lm/seHjy2Zs3JOMWjlmx6+E5nTaepQrizH3szH9Gvx/IGfvF4h306Gp9FAC4PhNQQkU+bV94j/SEcslG0fIA9J/64X19FqgEZRVsNxxk4DCNMFXVmyuYuyHxMh9QhxY0/6BcmS/KKI5wQjaEwFhbsNRXa3PiMLeGifmIS1MCDgbYnwFHOGPH6k0KvY2fAsu7GQieQpdYUkanXfpODoMs9oT0LmYqU696GpqCmXDxCMS8QS8qXtUFHAk3Ww1r7D07OxRjBzXy+JFxkE3NzwrVhrI3W7NNy9je8LuX/E06FEffyhGcvgsvUCNpQ9ET2R1Kjw8ViC6Im3qFiiDlElXAkXFoV7YRvclPk4fjO618hfJ9THfHrYXi8zveGJWTgeCdkM6MefGXx3N6Jbm7Ky2WYHNpWUPpmRL6IKk9cBNtUo4Mig/55U0pyRMoebRfe+Ul1Mcrm2XxgIN96zG51jpfv3WQt4sbkGnQGdBsKogYjXFEu8aTUHJ3UWRQlzmh8ygFkZujno=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 04:51:39PM +0800, Herbert Xu wrote:
> On Wed, Nov 04, 2026 at 12:11:24PM +0100, Uladzislau Rezki wrote:
> >
> > There are users in kernel. For example:
> 
> Thanks for the list.
> 
> > drivers/GPU
> >     /* Allocate the file in vmalloc memory, it's likely to be big */
> >     iter.start = __vmalloc(file_size, GFP_NOWAIT);
> > 
> > AMD-GPU:
> >     kvzalloc(size, GFP_NOWAIT);
> >     kvzalloc_objs(struct amdgpu_coredump_ring, GFP_NOWAIT);
> >     kvzalloc(ring->ring_size, GFP_NOWAIT);
> 
> These appear to be executing out of process context without spin
> locks so they're not really GFP_ATOMIC.
> 
> > Virtio ring-testing:
> >     (alloc_ring(0)), gfpflags_allow_blocking(0) does not allow blocking.
> 
> I didn't really look into this as it's just test code.
> 
> > net/ipv4/udp.c:
> >     err = bpf_iter_udp_realloc_batch(iter, batch_sks, GFP_NOWAIT);
> 
> This looks buggy in exactly the same way as rhashtable.  It's
> called under spin_lock_bh, and the same lock can be taken on
> the softirq path on another CPU.
> 
> So are there any safe users of kvmalloc with GFP_ATOMIC? If not
> I suggest that we change kvmalloc to disallow vmalloc when called
> with GFP_ATOMIC.
> 
kvmalloc() disallow and vmalloc() allow?

The deadlock looks like from below spin_lock():

<snip>
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index e4570bbed854..97aac4a4a92b 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -1025,7 +1025,13 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
 			}
 		}
 	} else {
-		spin_lock(&br->hash_lock);
+		if (in_serving_softirq()) {
+			if (!spin_trylock(&br->hash_lock))
+				return;
+		} else {
+			spin_lock(&br->hash_lock);
+		}
+
 		fdb = fdb_create(br, source, addr, vid, flags);
 		if (fdb) {
 			trace_br_fdb_update(br, source, addr, vid, flags);
<snip>

is that applicable for bridge update code?

--
Uladzislau Rezki

