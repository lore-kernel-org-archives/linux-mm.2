Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C94D1049527
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 09:57:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7367A6B0005; Wed, 11 Mar 2026 05:57:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E0DF6B0089; Wed, 11 Mar 2026 05:57:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DCF56B008A; Wed, 11 Mar 2026 05:57:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 39C6A6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 05:57:52 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A4C68BAA9A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:57:51 +0000 (UTC)
X-FDA: 84533330742.21.FE3CC51
Received: from mail-pf1-f196.google.com (mail-pf1-f196.google.com [209.85.210.196])
	by imf21.hostedemail.com (Postfix) with ESMTP id D34971C0004
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:57:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="AzVT/dDt";
	spf=pass (imf21.hostedemail.com: domain of wangqing7171@gmail.com designates 209.85.210.196 as permitted sender) smtp.mailfrom=wangqing7171@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773223069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iOemOY3GRBon+h/gNtOxQ4VEEGmdm3FWxbjJem+FfZM=;
	b=vfgNqsiTQfGQDQ97KuMNOpQRH2A+v3DYAkEXQyGaBQo5ZAs9cca/xdYOLa6+Kl1cCcuy5e
	NJVGHD96Ip6uzRm3p6D4ypt9peSyDH3a4VdgjbhSPcIm1MR+bCE8u86WRzVy0mcLHVbziH
	j7BEZlAQ7U52Qf9DLgXdbdWoVNYNFas=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773223069; a=rsa-sha256;
	cv=none;
	b=twFSSScpku2fyOosN5TKlnTheWRabIGcJPNyZ7isADJCyT/XlN1SpLlTuc0viVpMzUuFJl
	qQ6n2/ILFHYmmRBl7TNysCIbDVTIeiQK6jfshJW/xq9/wfD//BdCKrJS2t3ViT3ZDhPpSq
	d2V3HvMUG+e4vvD4ICeJ9V3FFJd8HAM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="AzVT/dDt";
	spf=pass (imf21.hostedemail.com: domain of wangqing7171@gmail.com designates 209.85.210.196 as permitted sender) smtp.mailfrom=wangqing7171@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f196.google.com with SMTP id d2e1a72fcca58-8299f1ca86fso2504209b3a.0
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 02:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773223069; x=1773827869; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iOemOY3GRBon+h/gNtOxQ4VEEGmdm3FWxbjJem+FfZM=;
        b=AzVT/dDtcELWwafhXDoR07UFAaczuB+mpE5+wtjWm5epnxDUk7UzsN3FltCSG2RPRw
         rzS15IodTUhux75XEzH1tqJ0Og8Gv3ZcKZtS4/su9eZft/LxiRWYYe0rFZa4dpbYAUZI
         oeLweh3KEimerlqnb5ksHjfTy5nAj/2ZDsxA47rMsLcbDsDE+hIDJ27OQP2Yn9rsjta+
         /TvaCw8EMI2KoPuQ+QDfynvb5vAt69EW8ewOCc1aEZVauH11evhai0GizSx6x8hjQGas
         IOn64Wt2W/BxpRT7Q1O51X6aqz4fEcqgHP0rFSgKDCxhuPn/EvgngaMENBg5Af6ZB4DO
         h2BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773223069; x=1773827869;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iOemOY3GRBon+h/gNtOxQ4VEEGmdm3FWxbjJem+FfZM=;
        b=m4mt+GJGQOR1FZQU/UzygkImDZqX+CLff3tmVpK9yXIhNAM3pIWtmdXVsAwtiqHf0X
         +lHXjG3cdr9odsPz8R3mkUkn2tBpZ3Ww0aMAVETYt88gGHnavWP8puxCCbtyir2287Yl
         syYZS6zaQdFEy55xSQWUEsBkgoFCxlIPs9Hp8/OcArWDP7rjWntJY2HriSb8kh57s4S/
         BYx51qj1rznn2/JXw/5J3Rml4fGSqlPdeQF8iiEXTmwtVjihmUTLgyB/q9i6FzRTvPZS
         fSFjBFXc81ZWA6ac5pggDGxv73v4Br7J/1pPC4+iIJXFmviyhGE8RMT76Z1tGcjZiUWX
         hoYw==
X-Forwarded-Encrypted: i=1; AJvYcCVTAmEyY7ga0hJ41W4WsqYh7oqO0lbWiovJDj5IAsqcj4hTW+jJO5wdXwj5hSe5sq3mQpAoQfojZw==@kvack.org
X-Gm-Message-State: AOJu0YyWlBsR5tRSwJ5q0tHJke+chrl2K5MNL6605+wJmCia8Pyg63cG
	sq6GzufudEcW0sa4ns80G23HMmjbNnmVYU0t/18NkMadVueBcWbnj6OU
X-Gm-Gg: ATEYQzzXm6U3I16Vy12rLgyiVk+E5kWhYuQ4r9xLXxCz3urmP9JYcOn9xJfN7gSi6Wf
	Ow581TI/RlZtlUFTSKDykOSr/n03nkByjkuUgwryXEGTBAlQ6VsVv+NYZz1nJUjtvAvmBO1LRXq
	WWSfp/d1EzaiZ6+ZEb5MyZyXmJgJz+YSNeAqdF8pqLspPTIDgUxv+HzZOBZURIhSxVE2BS8n+YQ
	5NhTEs1bdkzU4C2IM6ld1GvsKGvN1Fv+8KFQonzmpnBmMGx/yOoclc2KQhwxdalydyYfAgWiq63
	Bw0HdoUgIrnoIDDyPwEDD9immJtNMcVq/wbSjbQ0snCnyIecz8XKk/eOaLmhcy1eOjx8ecX1W7K
	rUyODbDX/5uxg6MwMJQl1r0YfsdWhmjwzNstg3W/x/C6xcV8HO+SxoUiPMlF+WskunBFj9TTccB
	ChL7EFxj6WdtXq9KoKbj4reCWXwQqqEUjWIDq/wchb0DKjw+RQM0J/hwT78xvr
X-Received: by 2002:a05:6a00:1304:b0:81f:3fbd:ccf with SMTP id d2e1a72fcca58-829f7094b3bmr1933452b3a.23.1773223068600;
        Wed, 11 Mar 2026 02:57:48 -0700 (PDT)
Received: from lima-ubuntu.hz.ali.com ([47.246.98.213])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829f6dc83cfsm1799712b3a.7.2026.03.11.02.57.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 02:57:48 -0700 (PDT)
From: Qing Wang <wangqing7171@gmail.com>
To: syzbot+cae7809e9dc1459e4e63@syzkaller.appspotmail.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	chao@kernel.org,
	jaegeuk@kernel.org,
	jannh@google.com,
	linkinjeon@kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	pfalcato@suse.de,
	sj1557.seo@samsung.com,
	syzkaller-bugs@googlegroups.com,
	vbabka@suse.cz
Subject: Re: [syzbot] [mm?] [f2fs?] [exfat?] memory leak in __kfree_rcu_sheaf
Date: Wed, 11 Mar 2026 17:57:38 +0800
Message-Id: <20260311095738.4177239-1-wangqing7171@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <698a26d3.050a0220.3b3015.007e.GAE@google.com>
References: <698a26d3.050a0220.3b3015.007e.GAE@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: s5sg1psgxekn3piz5yfpwzp85j8wbo5r
X-Rspamd-Queue-Id: D34971C0004
X-Rspamd-Server: rspam03
X-HE-Tag: 1773223069-754975
X-HE-Meta: U2FsdGVkX1/Q6CLdQY1/dTRjr40NDPiCo93C7jwQyoUv8SOYpbDojNqW6qgUOip9t1LuVITUmTzm6SzAGAMoFPJAHQ8+s3H62f3EheAK0IsEDKhGXWAllpVloXlkVdhzQ0UAuDagnnzm5pyXHmvMOoYpOQwg7QPiAUGfkwb47qLCEWNnsSYiCjaI7xuCeK7ih3+SJNXTE9QHRPZDVy6NX2HRkv1EnYN0RCC92L5qQ3x9cGmN6Z0enP82JE0qTDVb1hKdNqpIDGy1dbEkR9cr0Z4puZP+STpHlErq1QILi/iA3y3dFqC1O6mZ7XVS5KSOPrq56efE4b0VhZ5vt0MEhJyRcYul28tbARDEMNn+gaC6dqmorA32ZWNRgA7K2s+sGIVYD0hBgCm/tov4m7gl3t5wZZFCzSYWUInr172uVkdU4H2+RHqRDEO9aPPsTLw3qtuVlMUtStk+N4zxroHrzeiG/aUd7SWQ7nRML67aoYmG2cy+QOFEgZezvSTGNxhZEFPn1UEjlGxQYQuw6627S4GOPhXmTMO4UoyqFCq/Mv/GuAEeXgyQr3RwJ9l0JlnbMYffI+cQ0Zp0Gz29IU8+ViV/I9kzJGNtMOYvZMIC7gGrMs1t9gBSg61BKNGCdmMfBoW3R+eyGLxnsxSXxttn+WyBHxSrhyxkMMy3cxedrCfs/1bv4U3trOf3zIBrfjQRz3z/jpGIOaaFvc5foQvWk16syeDI5tw4NRcwShJvpLVXmiCA+GjJDlchxf9rqbzYlFzGuWi69zq/me693OfHTSwdH7t6IhMgcJA5XIUOZv86xlhiRB30jTrCnDJn44nnXjFdU4xGle5ZNsvc+dMLI01Vft9wVxhkjKzZMhWOLcJ3a+vlNY8n97V/q03a5Sk0OpvQsrSxmcBntTQ7TcG7dmalzDQuALkwL5P2gQnj7zdh2E/XQcd0WqqiLs7GtAil/MqsuE2g94+T1/+ma0X
 efole9h0
 m/DTD+SheCUgRjhXVgNc/czGCyQPB1Z2FqyG9nm/XygLWyJ9biKf7LQinHp1zBIw8VvNuMapAPQbkQjtQMEIaDeTjyQQ663/JjK6NSfloALkklGOdYMXgsUCG5p93odLy1X0FfaZQ+FUIhhrxAfOH5qWwFeffYCUuJa5lKB07A26xvZOjiU7A7ocOSzywAK31ALTD/Mqn9bXl5QNXbgt3YpXfFGTf9d7PDgGYlEMX61HABgRwxQaGaBrdo/6YnfuA+HeZyYUEItdwJ1pAPgr74tQIsJxrXettJk9MQxPa9OTi0/3rGkBtCK4bCAoxxFj/nO/MGEPCzf9AKLryOa1sOat9voMLnVJyAE0N/kQ+2BA86t1vYL0h+ikWS3GhDrEXYHHaMHntSSaB+e1mTebPiyNmGc2Ay7YtuexcMBIzHHeipmuVOuv9byhfojOwfjHBvPwd682XOukT46BUwHEIOi0nBxPt2xKmuI+xkw+dUvWztq4j7gPwHCXqzg5bchcXXbLNQsVFMaASlHTJRkJJrG84atHVmK6SxKbtXwwJXEbWzZ5sN1gavWJ6qfI7Q25Pey3y1yWJEN9OuluMs9qRBwtTSLesLuBL96/at1buZLCQFM+bx9QhiFiaa+Urpr/8MFVYt7atE2MXOrtSJuOXO/FXFvExz0maCGyN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

#syz test

diff --git a/mm/slub.c b/mm/slub.c
index cdc1e652ec52..f029003e7368 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2629,6 +2629,7 @@ static struct slab_sheaf *alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp)
 
 static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
 {
+	WARN_ON(sheaf->size > 0);
 	kfree(sheaf);
 
 	stat(s, SHEAF_FREE);
@@ -2660,6 +2661,7 @@ static int refill_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf,
 	return 0;
 }
 
+static void sheaf_flush_unused(struct kmem_cache *s, struct slab_sheaf *sheaf);
 
 static struct slab_sheaf *alloc_full_sheaf(struct kmem_cache *s, gfp_t gfp)
 {
@@ -2669,6 +2671,7 @@ static struct slab_sheaf *alloc_full_sheaf(struct kmem_cache *s, gfp_t gfp)
 		return NULL;
 
 	if (refill_sheaf(s, sheaf, gfp | __GFP_NOMEMALLOC)) {
+		sheaf_flush_unused(s, sheaf);
 		free_empty_sheaf(s, sheaf);
 		return NULL;
 	}
@@ -5027,6 +5030,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 			 * we must be very low on memory so don't bother
 			 * with the barn
 			 */
+			sheaf_flush_unused(s, empty);
 			free_empty_sheaf(s, empty);
 		}
 	} else {

