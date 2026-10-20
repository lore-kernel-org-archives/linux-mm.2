Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85EBC60A2602
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 15:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=X4MUhOKV
Received: by kanga.kvack.org (Postfix)
	id A30C46B04FD; Tue, 20 Oct 2026 11:19:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E0C96B04FE; Tue, 20 Oct 2026 11:19:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D02F6B04FF; Tue, 20 Oct 2026 11:19:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 68EAF6B04FD
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:19:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 042804027D
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:19:47 +0000 (UTC)
X-FDA: 85343364456.06.273D058
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1EE0018000A
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:19:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X4MUhOKV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792509586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EQYvwkMnfu+WDRyfOhAk5xxSPl+eH8WAQuJdlRRhiZE=;
	b=vmiYGYd/eVSuFW9XacBGAmVPnRzdtMb0h7CTXFbt5Xw7z+dLXqWLEyNipaO4Zy7dWsPcY/
	EV40DavEGl/IKIlQ8zrmwHGWfs3u4iJM1FBoz402WQS6YxU4IF9A7vQiOJ7IhU3QRfDV7p
	aB6rNAGVqMgDBhj1jRaokipvnL2Tbco=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X4MUhOKV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792509586;
	b=yuviLrhMIOE8kN5lXu+wVTrv/AMSMMqON9qGgXqkgjR2fomP+h0c+rt/+gT5eHlicBAbX7
	unjXK3P/Vce4+I/xsU3v6eGGDPXy9XRAcJoM0wiwd1CKq14WCYPM5MBeKBZljtI4eZerud
	P44d2aWjaI8wCWs1dm0pSAJD4Lmsv4M=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-881269371acso385033b3a.0
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792509585; x=1793114385; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EQYvwkMnfu+WDRyfOhAk5xxSPl+eH8WAQuJdlRRhiZE=;
        b=X4MUhOKV++T1EWi2tPexcNLDc+juIS/QAxA/3zFo6jTWGi+Y2Hywn5xUnNWxu0XxxC
         jSHBWjdGjTQHBg0rGAtHhet1dxvJxr/MYu4m+Mfw09I68RACkcQ/HyVvNLvk6X+UmudH
         Dh7cLPxLvsM6HPTZgDPwGQzwHVw0FL42Gk6OzNrP4h4mlwDL7OxMAQVQuYwQuA43Qsi8
         /HgwsuddqYyauK2JiHBIJ4jpcbcIEL12uiVac2iEdjvJWxsoHcEa5lozwlczF2vfy4WI
         zMoViQlVOMduaco6lIsOdJ5hBKF862KxYRu5zrIxKqamy/yTtMOGhqdn+pUKxffKQ7QB
         c3qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792509585; x=1793114385;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EQYvwkMnfu+WDRyfOhAk5xxSPl+eH8WAQuJdlRRhiZE=;
        b=H/00weigiOi+UCkeeY3QdCSCWJhpB16f7zCu96l9fAEl40iXJjywRClqY8Pd91mCbQ
         VUUv/rnlvAAmy1K0cksbtTXv1GQIDguQNid7PzhVA5ee0QWEsTByvkvyqf66JStugJA8
         CaDMgn95g92vhgj010ADH12K5m2fL380+WCe7V02bTTtbXtCwrCG5FRbD6ehXwD1ZDB8
         g72w6AfWyT77M0KUULjkGFG9aUdEUef0bHL3BYS8MNuudTM6IBRreaCfeZfA4mxI5Eq3
         bDmyWazyqgpEwEQqsfo4ZyjNKCTWjvXeqGTFfqEHxQ3r6AMq2hPQj50f151QbWIWWYXx
         3wDA==
X-Forwarded-Encrypted: i=1; AKwUvBwunexkEvxCQCJ7iUl6JOUZScG4Glc82dEQHOFE0tESANGppDlKjZhnERwXyPQLfKH8WZr//kzwFw==@kvack.org
X-Gm-Message-State: AFq9FYJ7HDGmr5ywHJ34vQuHOjzbanq7M/f4C9scjpuC/nQPkiW4mHw3
	NfC0ilskY8x6ZVFwjoCcNn5px9zbtsrchMuMZL50JGDzHPYiqL5ZjwKo
X-Gm-Gg: AYBFou0XNS2bLl/ATaflWdgmxWrTflP58X48IhmI35+qyy/zM5FzKpkWIVLve5F++Yn
	voxT6Y4aNgmn1NqeYWWb2WEjZ4mqOim+VOxJCbe7xGQLtp/VI/4Q+cFK014xXPIsM4oTCC65cZW
	yyZ4L+hhtg4NspdZZIw+9253HMG/Hjzvh6o8C9og5zw1uN1f7G14dXCjolMlIdyTlmfknbhh6K8
	XPAMe7o8upxpiUnbT15NFFjL2JJnYQu30lKJV+StrYtw7y1p28FPrq0GrHJgy3p89W6acbpatjO
	xWpI7921TeLFp2dLOfR8A/wS73pKsEticXTeLw/kzsGB1EMdGNE4wxGHLHGBI/OB7KxzNRUBbvk
	G4VR7XJSTkp5G3/AEsmgepjPGJvJijA33fJBSa5M2KoV4sDQpHJeJkM9Ua3mK4MOB6ioj89ceqy
	rnLqdbhUGWuzbIzPmamsg4uukYf3aNe42K76FaURHnN8X7VBG8xgNxgl+KlUXJvmXbBVAbG+a1J
	nuaCx4haC5vC/jfBnfBM6vP4vcfJ/Ht8hThBVXltva1xun6MEmPnw==
X-Received: by 2002:a05:6a21:4584:b0:3e1:3734:63e0 with SMTP id adf61e73a8af0-3e26fb99eeamr1595875637.41.1792509584766;
        Tue, 20 Oct 2026 08:19:44 -0700 (PDT)
Received: from gmail.com ([185.220.238.37])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89f56c89b97sm4994338b3a.12.2026.10.20.08.19.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 08:19:44 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: Kunwu Chan <kunwu.chan@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	ljs@kernel.org,
	dave@stgolabs.net,
	roman.gushchin@linux.dev,
	stable@vger.kernel.org,
	Kunwu Chan <chentao@kylinos.cn>
Subject: Re: [PATCH] mm/vmscan: reclaim every zone in per-node proactive reclaim
Date: Tue, 20 Oct 2026 23:19:29 +0800
Message-ID: <20261020151931.885951-1-kunwu.chan@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261019185002.3428594-1-gourry@gourry.net>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1EE0018000A
X-Stat-Signature: 8detipg4yyaq9mx9xi4ksearagfn3r9e
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792509585-964397
X-HE-Meta: U2FsdGVkX1/RPFWCbzrYcCuXbVX/GYlp1ppJuXA/BaQRrAeM74puzld15K+asnkkaK+SS5A2ZHdm5w8MjCwitQNFccOBM9y5fT44Pjj3C1d7nDMvQ30Gzi0PGPxCM5T9ftiLlkzrKNNVB7Px1uvrUETcNMDqREPPHIuMcZRgWwfmjtNIEMESVDpnaxmqC3n3nFx0lvy21luCl838xQI5ngrBltoLQueunra0FO9BVgtUW4JqeyYB3m08jdpgNPuqBgBNwu1+uehtjmJ4I3vUnrEANRQi87INbxKMI1GpB18APcRyo1noCA9AEodm4YtS/UN5tJsFtf/Yvtl6HO49VPW3TANM3WFhxRSH+C1RoMscagDSl3NCe+/BCGf5G5QTxx1KNrNbOuvx4RE4WSWBigGy4ZiGRGY5SJIIAt+L9xbbmuYHYjlrigsZx2yashqJ9sZX2YlW7MfLn3uMUqylSvCAMBnhxpcmWiN5ZxWDdqqEdwMKF7ODcBd7sgfBMJXdgpXlP7p3SG4GA1XWOzMNQYhdlNorN8ENKgqQMIB/J3vMvCOKg1mAVIQavJnOasZezQ5y2svXlbnrvDuux8bJ9+tiDr4yOa+Jg5Hpll9SgrE5xIUFifscscgjZTa/ygby9zQ3qx1LSo4tWtWb3X12Nc/SfD2FyBMYpl8OvBNNaU6lv/EPw3Wg5PZFky99sLVB0Jl/LNpMBaWac0bTtYzil3n3V2dXwk1DC5LxNh1Cn/LKWA3wlnXMLj2HM7GzvPuKtBv6Exm0DtOZSkR09OQ+u34qmcszgB8qemfD7Le0mt1PkuwsNrXk3k+nvnMK34Zff8E6k6BXDAUu0kwieWM9R49YsYCCKrZ6gkpzs65KYfu0rahSOeinlIkoxOFWxWkT7Be2HkAtmG9VUWkKYh7jVXKqXLOW5+BgIqzKs44IoZHoUMXKuq4QFHK3ZD3qygmQtoWQEnETZwYdf8k8HxL
 cjGZ/f4R
 tubqMOK6OMJg5fnBqVUXYW7CJBubyqIfPn+6GkDU8ilTPjgHSZAc3vnpj2RVEnoFqWNR70piJ9714RiDQrRZYLbYEUDyi7p0ju1qS0//lIC5UQ03j8gcjbBZgfsBlpSM6wrugodlnd4MzKMZumrkTORvg5wJHCznkjSzCFNSPJpFRuYwuJvW4AZrG54u9WHxryKe9HsORP7eQ0DaVwAISAnWLCbmggK5VrjEYVJzClHHfIYkt9Onr34jjmsu+/x6BPO92XaUOWczDzw5BBdYqfJmsSmT5LZMa72VRjJYtpI26ANI7bJWBsS3ZnT8ZVaQzhtPlzG3HYx9bvGtx7zH3YqbcmZVFzSzy/zew4zEM3NNGxUpu9FmHFziSR/WjkV+sb4tW4S4p8x2Zl8ahc+cP3wS9bZNNUrE+3TDL2ogqG7DSeda3ICn1Lh3Iz2wjYR6LemS7297F0hgULQ7QwW78vX/WzHwO0WldsRI7D6f8PsG3KXJzwDkN/drJmE5V75Ug4ydRnELdXcPE3z308uqnyFgY12N4+mzP9TSI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 19 Oct 2026 14:50:02 -0400 "Gregory Price (Meta)" <gourry@gourry.net> wrote:

> user_proactive_reclaim() limits per-node reclaim to
> gfp_zone(GFP_KERNEL), which is ZONE_NORMAL. Proactive reclaim serves no
> allocation, but that limit makes shrink_node() skip every ZONE_MOVABLE
> folio, so writing to /sys/devices/system/node/nodeN/reclaim never
> reclaims a node's movable memory. A movable-only node, such as dax/kmem
> or hotplugged memory onlined movable, reclaims nothing and fails with
> -EAGAIN.
> 
> To reproduce, fill a movable-only node with clean page cache and write
> 200M to its nodeN/reclaim: the write fails with -EAGAIN and the page
> cache stays. The same write to a ZONE_NORMAL node frees 200MB.
> 
> Scan every zone, as memory.reclaim does.
> 
> Fixes: b980077899ea4 ("mm: introduce per-node proactive reclaim interface")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  mm/vmscan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index e82ba737c028d..90f7a7bf4e426 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -8180,7 +8180,7 @@ int user_proactive_reclaim(char *buf,
>  		} else {
>  			struct scan_control sc = {
>  				.gfp_mask = current_gfp_context(gfp_mask),
> -				.reclaim_idx = gfp_zone(gfp_mask),
> +				.reclaim_idx = MAX_NR_ZONES - 1,
>  				.proactive_swappiness = swappiness == -1 ? NULL : &swappiness,
>  				.priority = DEF_PRIORITY,
>  				.may_writepage = 1,
> -- 
> 2.53.0-Meta
> 
> 

reclaim_idx = MAX_NR_ZONES - 1 is the right fix — proactive reclaim
isn't serving an allocation, so gfp_zone(GFP_KERNEL) needlessly caps
the scan.  GFP_HIGHUSER_MOVABLE would also work for the node path
via gfp_zone(), but that's indirect.

Reviewed-by: Kunwu Chan <chentao@kylinos.cn>



