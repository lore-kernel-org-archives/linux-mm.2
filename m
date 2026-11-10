Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8F67606B2EC
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 13:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=kJ4URw8B
Received: by kanga.kvack.org (Postfix)
	id 0A4136B05C4; Tue, 10 Nov 2026 08:11:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07B776B05C7; Tue, 10 Nov 2026 08:11:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED4716B05E8; Tue, 10 Nov 2026 08:11:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CF5806B05C4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:11:46 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 686B7160386
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:11:46 +0000 (UTC)
X-FDA: 85419246612.10.7C57BEA
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7EFDB100010
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:11:44 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=kJ4URw8B;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.50 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794316304;
	b=ip4TZHxXO3zwsRw4K3oMgO/Bea7J2ZtIak2BrstM8BuTkrfCNXxZr57BhmtudZ9YlMqHHR
	mO9xBb8oDT5dWUO7fB0XBzLCv8iBQ6uQxSZsJpIbJ/2tz4btnGHlliXvDxq1wxj+GI6cgO
	fYhMsxMcMsy3l8XG0nLMHSK4Y4OalbI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=kJ4URw8B;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.50 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794316304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v/SgEZWrzJNE/7WZqBg/ymw5X2Lr4Ksekr/q2IUMa7k=;
	b=NO5RQRwGlxGMWmqjXFBNXojpCQNFuAhr5vGcadBxoJ3kJ6T5EBJlPLubGkB+ER+Pz6ULUc
	83Fo7VSKe3uRjBUKuyRMzxyrc1G7H8uioA23CLBcu3b8KSJmJA2aecgvq9qYkEtVJ1MqKe
	CcI5QbnABF3pZ/9E2rbpJzG2nJG8c+4=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-91ebf4cd218so18096976d6.3
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:11:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794316303; x=1794921103; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=v/SgEZWrzJNE/7WZqBg/ymw5X2Lr4Ksekr/q2IUMa7k=;
        b=kJ4URw8BDFv3LJBRKRljA7HxnDBe4f9c4HEByERk3r/WYYyM1sL3XXk2NFYYruTtTW
         /gSiJt2XoKSXb9WGjz6LHadoHFLfvqo3wQJLMMWJ2HfR5v116FePYxZQYXoSRIuyPv+Z
         9f8cLbpW0W2K37IkDebWN99+tH4lzWqkL0Y1WCirefhS/EbuGLLFBXenCBs+7I677Cam
         HNYZyjESC+Lpn3N4zH2pU3k3kVYpCz7cYfttJtYsL8ZcLcnKRyJR1GOh+Swa9tJW3jMZ
         yhheDDZclweTMpL1Xq//p/XGZVbMmtWyqrdoqsQhyG92qU10zCtEOyrxjkJRb9nY2H4U
         /geA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794316303; x=1794921103;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=v/SgEZWrzJNE/7WZqBg/ymw5X2Lr4Ksekr/q2IUMa7k=;
        b=dSbjMIzHg9GBh+aX5s+G96JymlVoDjFBllE9aNqQy/hrCfUb47ey2EjoGSrp4yFD87
         SVd/swid/vovFUQHQnw3Ct1T4sAEWrPfXkSqqy92qUAE1ZGyLBtHWiRh1/gvw9ljgCNT
         lgEAUzkhOsU68LIzY8QfjM//1+ZWldkedYynCSMckcGX6OvKBewaKxCLb2uvgNsdpOEw
         XynNAc2vcvPhJ/6XRB5/qr7rqn72m6GcuGbLYLbVt/WWwgll/tnaHdynx2h7+X8VtxX/
         /6JX9wspQLO/0Pe8SYDwxAX5hRVwcqicNIkgBqr+09xWnhF2F1ThPTCJWRPXEyBruwel
         8+8A==
X-Forwarded-Encrypted: i=1; AL+hErEa7LY8BtlRjUWv8mV1ikl7PpyN6wURby8tSFziihDaoCrJACsUCpRjblh0v91Ldeo0f2ttFfRKYA==@kvack.org
X-Gm-Message-State: APuU4Z+WfHycQ4gUtMBokom4j60nl6oGYzMzPTkh65IEqaPfTNpSKJFU
	Aavi28gtgXJFTdAdZ4wEpQWFdOrrIKvcqkPRuBWmNyKM0vyl+a2KYqOH3j64smH+R24=
X-Gm-Gg: AYBFou3zHdHA9dJFo6XAprtD5Upt94ihOf8tHngpd1E7V3agLZ6DLhJqmUWiWR1yMXB
	Rf6W0zSC/6etUGBq94YkSeIO4EkB/26+QmCCZTJdPF6iag3s/v6Qe8GCn5Yc6sPjoXdQf1Q+YQa
	jaSQBWdl8Z8GpUjdTSJmrJdBVEI+abpD4DjbzDxMdLqFtkb7uByGShoQZEIThLumxa20uLe15ct
	7IuyJn97fJElaWxGVT7kJjkjFvu7CsmNHZqqoHqEig3FYBKE+1KWBs3dgxP1ayyXnGyb7aAmdMQ
	wBLFwt4TZ+9YJFl70ocIMlCWMbMfGKCwERsHHsrOS4pAgAlleCumJwd92hPrJjagfsP8lALsw56
	GLkV1vJzWiaDi/ePBk3sDwSJHGb2n67KlP6Y7hOjr5TUZaRSEQVSfd+rSU5SNEX7UHy288eNmq7
	tqB+9IMf6w4VzmWFPahERGlaV/+szKbSxrWEXZqfjlNkcVcMyyHDBoVyUfHFeh4pNb7n4CRNMIU
	6UNMSOSfsRq9KOWuCtecqVy01irEne2DKd9JuKey05Fu5WFbyF32Zi4zjlZfWTw0pcG8ZtoEFCu
	dGGMqmeQ/LbHToUz9DIFnTvO//Egr+h4bCrZmkzPjla6IROuNzkYuaG44DNYmuiuBVrjDJf6Kmc
	+ygzzIjI=
X-Received: by 2002:a05:6214:2266:b0:91c:7a0e:3385 with SMTP id 6a1803df08f44-91eef9b7adamr41656946d6.49.1794316303415;
        Tue, 10 Nov 2026 05:11:43 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ef04ada03sm20492646d6.7.2026.11.10.05.11.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 05:11:42 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC PATCH bpf-next v4 1/4] sched: add helpers for numa
 balancing
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
 eddyz87@gmail.com, memxor@gmail.com, mingo@redhat.com, peterz@infradead.org, 
 juri.lelli@redhat.com, vincent.guittot@linaro.org, 
 akpm@linux-foundation.org, david@kernel.org, gourry@gourry.net, 
 tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, shakeel.butt@linux.dev, 
 roman.gushchin@linux.dev, yu.c.chen@intel.com, zhao1.liu@intel.com, 
 tim.c.chen@linux.intel.com, lizhe.67@bytedance.com, ziy@nvidia.com, 
 mgorman@suse.de, bpf@vger.kernel.org, linux-mm@kvack.org, 
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261110032913.71974-2-laoar.shao@gmail.com>
References: <20261110032913.71974-1-laoar.shao@gmail.com>
 <20261110032913.71974-2-laoar.shao@gmail.com>
Date: Tue, 10 Nov 2026 08:11:41 -0500
Message-Id: <179431630193.789062.16833460142171738145.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: iusa7ry9ofoyymop1eppjgunwgw431h3
X-Rspamd-Queue-Id: 7EFDB100010
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794316304-786081
X-HE-Meta: U2FsdGVkX18qJ/fngl0Jd5Y7dUweT6BCnSEAcdeoXFARSYqhPx0HDMotKM6ToWL2xOkJr7CPshYv9vo/nsmypB8R93DiLys+YBJbq0BtfOrHwiCxXFZRRJpqcfZCrnOrc8+ul2NAfKcYaeo4pZ/lLskHVN6v+ezYD6KMZrs5ziqlVoQ6YbcNtmtOcu27kztLXo4WeCOXoHgk6JGm59dVp0T2BHOvckXgoTICGIWUvDZCi40ed888FoEVg8gcXL1OVPh+BbmMtnK+nOqBYn6lCyu5KwnJA7/df/wdspTlG/ecy1DqTRNIw+nnYveE+1Ys+tJrVjbHqv0RS+xtSryY/lBWljeyo+jevVLMajashGObrsYo4hmO44zxCKmV+rtmuSXsRVWd9CxM2EzQ//FYzF+Z5/MWumLHo72KkqauV8PixdlWtZoWtP90F4twJG0mLPRF08iHsPPrqeLm3z0pZWe6hrA/xs6459uVr2ZMA7DxkbAiNLhdl2BPtIDy8imae/z9z+7qnropmyaxTQmVaDkX8UUyT+gQcSIOafgOwln0tjc+X7pDwZw0wjP2YSuDEISoOwQ0kBM9iL+NuOxa1+xWDv5CWbIcktloV8WpwX81BDh1aPG8r4gibkIyq/YyvSv5IyajuA9yVgaEoT94GTvhEWcuy91eStaYGXLPSOwUFcQHxP6XQoFfi0RArMltDZkB1R646zrViiLfkH+Pai6HMcSgiyAEa5Y8z2yVL/W8iZtGN9A4FBonxGZbMdedbi83JPLO3cW1bLGizc9Sz3IA0INumf0gylRNfDw4MidP+57US0ltBbDAWFhaOfdkbiv6LiSb1mpe/l1ZcTWiyhByMP7u6wGo+rIhJcfKosbiY3i4BDanLnCfX2UqLLW31EKelgCuKeF+JmhPP/8o9ymxeefeG8aKJr3o78ccb8MNs/yVsAtHyAJRGtKkPhp7rYeMYaEx0kZ+xxgkqVe
 vngw++tp
 Zifx9xFq0+cFtgWBWq0Fjf/oa+zj/qfbBIftE1sMDkpboRX2CgLd2NED9ZobQuFSP4lEVBP/RNTfmNgXF8E2NuyODvgkNKF0KEiUMs3LVpuaEI+YUWXA9pl0o76/8Wszyepi2VStah21GBxX4Ph4khxjuEeqgE9UgLkWBZNKjxX3NOeZTtO24fLU61MicHbxarbYUi8UXAWSXvWq71tMwFtIZnihLb4L8iqjG4oC/dxiyq6tCXtBg1caGCC3hOva4KsenRzuz4B7jYV7ts7cKOm9Nm7kmWXE/OJsoBqC2SKOGh8Zb1t5AbJr6ASQr9y2ULr0VrDS60Gxr+YOWw/q2jvjwwFbBXkQt9oPtLj9sqWKG8Q0gVuWXt4ENTHZjYpEE0Kb+BBeJ6Z784PRFeis8KuK7GoA9fdal6a0a84Kul5wAhVlaGlvxDjdlqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-10 11:29 +0800, Yafang Shao wrote:
> Introduce task_numab_enabled(), numab_in_normal_mode() and
> numab_in_tiering_mode() to replace the direct accesses to the
> sched_numa_balancing static key and the sysctl_numa_balancing_mode
> bitmask.
> 
> No functional change.
> 
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Cc: David Hildenbrand (Arm) <david@kernel.org>

Agreed with Zi this can be picked up separately.

Acked-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


