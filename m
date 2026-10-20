Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71487606A327
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 19:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=rNX5nGw6
Received: by kanga.kvack.org (Postfix)
	id 864AE6B054F; Tue, 20 Oct 2026 15:59:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 815B86B0550; Tue, 20 Oct 2026 15:59:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 704506B0551; Tue, 20 Oct 2026 15:59:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D02A6B054F
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:59:00 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D420C1C37A0
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 19:58:59 +0000 (UTC)
X-FDA: 85344067998.17.847FF5E
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf07.hostedemail.com (Postfix) with ESMTP id EE66C40006
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 19:58:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=rNX5nGw6;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792526338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d4lLCzzpRL6P4ForBOyjOrBe3fXm0rVhcelSyIuV9yA=;
	b=D/uaRatV1z265HqlcNJayy+YFsT6FLPs+dA6J/sUAjlaTlm4N2zTimZ+g2n9OALI7xDTdF
	LQa3o+cRMqTOtfbP6RMeJQtuCnmffOxN3aFQiCfUZ7SZd0qCjd08rYIG7EYGK0vkUTrruQ
	9uzZCfqipMsMsTqsP0j1EuRsb1O5SlI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792526338;
	b=tjm/Mesc2ue5QhPGmHD4p9GGGZlCmWLgz2eUI6GbL4KEDpK7DIYY9Gvw19T1Mv/TMtTzyP
	VttgjqPd2de+lR78uOLhffFFaXCmiaYtYyAjhryGs/d71cXDzhWrdY0WNlxC9IJ6DI0/xN
	1XUwi9Cws43+ZKnBmqYAW+4dWe6Nz4I=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=rNX5nGw6;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-5365b48238dso540891cf.0
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 12:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792526337; x=1793131137; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=d4lLCzzpRL6P4ForBOyjOrBe3fXm0rVhcelSyIuV9yA=;
        b=rNX5nGw67CuBrOH75loz+dNBSgzQCzVcwAZxTJYdQ3D9hVSOPBsh/x0Pwb/cKisn6D
         Zqs8bFhLT+z4Vxpbz1ayXVsDDuWAKj11jhDrw4aocyiHqxrsiOUYHQ9mmrlAeqoysZB3
         gKOiLox95DpWUttnySnIA6mLZaNna0+4szXRxxucWnqk0oE35na20mH255H5z8EqC2xC
         f931Twz5EOs9anPiysS4A0FY+i2eWgBAM5FENZuBDZaQ1l5A797AyGwA3aWdN4qHa+NK
         AAeOAU8E2Z/gWwNJu6dygfiJonC4TnM/Trm02Z/FsVZ0kwlvXQUf5yAMZf7zzhs/xgqb
         ab6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792526337; x=1793131137;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d4lLCzzpRL6P4ForBOyjOrBe3fXm0rVhcelSyIuV9yA=;
        b=Rm32RRrVP1m4OW86JP1ux6V/yeVUvzYtQ5swq1W7e+rXonUY7FuJbSvCvaXUyP7cTg
         zRIMkCkxSxu/7C8V9ylhkS68AwDWtJ9zwwESdT0qarrZj0x3ksaUdKOipw2z3WnSWATS
         xvzrACRt6MmJhYSe5TC4ei+g9GHB79r94i9ScptsGbP9paQ+j8OfXgBq8YYK5uU73Qky
         QnU4s3/66KPQI27Qyrn1hOSuSwVI8w8+p6rb36IU/M0wWWAn+docuup2bXfrjTqv3Agx
         YOk95PVWlTiXdDYcZ6NbUag1qQ/8SUfhKVUbzi2tyAEcyGQCgNaIpObAUf/S4Xac2huJ
         Nr1A==
X-Forwarded-Encrypted: i=1; AKwUvByAMOc9GdJCuVePCBtsxGRuUu3XSjl1U69sx1oZCqYrKkZ4/dQv4bfJH+KlxxpLv5JUYhWkZuTZAw==@kvack.org
X-Gm-Message-State: AFq9FYKCmwPAkea+6xQQbnJWXtqdXnpq71MqIWOSku1hlpm7GWs8UNx8
	9LhUUU4pXua/b2FqdDVV5x1WVFceBMSU/9CWgxa7BCqrA1OTWg9r/YAjmounCEwY6fw=
X-Gm-Gg: AYBFou3TXoOjDYcZzsKTxhyOVdukBcZFOzfHadM0SJNz9Mli7h/Fyt2rQ9/MnoJHxhi
	C3wXvk4Hu22ikDCvYTMM+M/U1Fp1Rc/tEwrYRpcMcofvGm42oiAmdgh7LwNxmAtytgBO4ouaG9a
	3e6rWGdPRccyHwp/fVliNiJyruqiuux/4yjLefIUo5mnftvQSXK3zdg+iQue+aRJclN+o2IH6YL
	WHEu21vBKvW3k0wew/GcYpbMylAwi3WK2pznbsC3GYigtOxytgw6heWf9ly2iea7bbAgFE0yi4Q
	9qyEm68+qX7ggCFbElLaPi+dEJpapYqbv3q5wjGC97CYAP1AhYpTeIR+lCOtN6Cvply6fzrSb1Q
	dThGPNncP29pWa2HujBFJMOb8ktRBY6V3ELjnkCCgqYBkOLr2MNbM3b1mR5WDoRdYCYxa+08jK5
	BWoKq2ttMEiWV98ltust1rLFbOcYevnRRthPnV/VCXesMl5yx6KnUJ/5cyqSCFdkRL5FDjmIS/A
	/aDkUKlJf5UOZEIsfX2CTi0PEFi+Andcxz/Yy5cEhhl9A==
X-Received: by 2002:a05:622a:148d:b0:530:d429:c70a with SMTP id d75a77b69052e-53645fa0b84mr188171321cf.26.1792526336944;
        Tue, 20 Oct 2026 12:58:56 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53698b427f5sm3856891cf.15.2026.10.20.12.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 12:58:56 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mm/vmscan: reclaim every zone in per-node proactive
 reclaim
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Michal Hocko <mhocko@suse.com>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev, 
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com, 
 yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev, 
 baolin.wang@linux.alibaba.com, hannes@cmpxchg.org, david@kernel.org, 
 ljs@kernel.org, dave@stgolabs.net, roman.gushchin@linux.dev, 
 stable@vger.kernel.org
In-Reply-To: <atcc-91WerBlJ_Q5@tiehlicka>
References: <20261019185002.3428594-1-gourry@gourry.net>
 <atcc-91WerBlJ_Q5@tiehlicka>
Date: Tue, 20 Oct 2026 15:58:53 -0400
Message-Id: <179252633386.238494.13826191476140121288.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EE66C40006
X-Stat-Signature: 9u3mqco18s4qpbpxn9gdp9k4bnbhm5kj
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792526337-861585
X-HE-Meta: U2FsdGVkX19Guw57qXERD7EpGsSrTx3jJORYFGQORp7DtqhsJJuFscdvrGLVYzaHS6rXCm1tETGODX2myybL41Bvb9f2GWGnL/N/hiMfzldk4ce5sg+8+cyLbSrfurK/VryYvUbS5bflPmITsHMK2HazCjtt7sKfEYp/xgYLFFdM806Cw2iZVE/1KdpJxs3lmL25twQ/mVtR2gxDDuRWTJ4cbfP59xlLgd+11QDOhLuePI5aV25FJ/TQLOZnt2ghg6vO7N3+dd2pTBl60G/J2/1YIlLO7kCrBTGuZaiTceaidg5TiXhVTeLkhAmdp88NveAINkH+zdbA7mf3e02vFZ54RgrmkmQHsKn7QFw0O+LOavQtRmqksB8Kda7W+Fs/5upPvWTBDoZ5aY+SksIFk07j3v5E9ejARGMdmNpCQOybbbBWZ3KwaDu+KHZE/3GmL48aAFl/rONJkcUbIw9LpzIz1KcQFphnqVWRvuxQsZHqTzS1vUZGdzeVCDJUdm53/DlrTmvMo0KyBX+lAA6XlWnFCB2QvpRcsRWRJG9H00HMLpXW5Sz7uS/l33Yx4PB7948d36XxSQoWWtC8F98IaWMA+xYt4vMC+0cSsS7bpjsC3HTNIGeIui/kCXFWXELf/OQH/TxMb31Lqn3N7NMtn4srqhJtCx1i8ou+bfeQ+w3Oi1eLrnMjCad6kzYzs44DB7ZrGqR/cSjWl1nSNWCHqba7+zu0keQaP7jV28U6E2jKZwFhaRq99NuWGpOeZtvyz50mnA7h0w01+OKng3wIk1LUK48R0SvDeNssAqHxmqW1bZ+OWtr49AttQ2wuiySsp8X2ki3v1BOaj1mugEt4QeahtF0RwhqqvAg8J/CwhMlVjPIQkAv6v4un5XT0u1ZJYQF8Sk9e+JHNWXPipgGGd/t0X5ntY4/OCH2P9lS/iwtDA2w2krQBC3yj0ScQnGH+Rw++hx1cImSKeACTCSO
 mhsjVBxA
 g5ds4wUzYaillvpMdtgMZIswGUEVRSimT9L4+MXrGhfprlAUUCqQXQWVNe6P6N++uLV2VQKwyXnxiwschYd4HAcECZ7YxUA3RbSRiZmxwK+L5QXJqNwREAI5C8oAE2vdbkbrjohYoigKwNheNEuBvPL0TwCKGBkJ0ox1keq52DVvXNarTikGSAX1MxwpoqXd0Mj5Yd7Cpvt5wtznTHq611EGX4GI/BgelaNJ7KwMhd0GmA5/nQcxJZDiSQ8zTBf5EnKwKqFNSVKSyeJecF89sdYMJtgSF/JNFlk88plGm7em5XXppsSN+5BPM7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-20 09:49 +0200, Michal Hocko wrote:
> 
> Would it make more sense to 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index f11491ee9ed5..e07db9514e59 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -7963,7 +7963,7 @@ int user_proactive_reclaim(char *buf,
>  	int swappiness = -1;
>  	char *old_buf, *start;
>  	substring_t args[MAX_OPT_ARGS];
> -	gfp_t gfp_mask = GFP_KERNEL;
> +	gfp_t gfp_mask = GFP_HIGHUSER_MOVABLE;
>  
>  	if (!buf || (!memcg && !pgdat) || (memcg && pgdat))
>  		return -EINVAL;
> 
> That would take care of try_to_free_mem_cgroup_pages too.

funny enough, try_to_free_mem_cgroup_pages does what my patch does:

struct scan_control sc = {
	.reclaim_idx = MAX_NR_ZONES - 1,


now, whether the gfp_mask should be GFP_KERNEL, that's a different
question i think.

(tl;dr i think my patch is still correct)

~Gregory

-- 
Gregory Price (Meta) <gourry@gourry.net>

