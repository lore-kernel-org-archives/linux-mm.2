Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 458BE606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 09:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xvRypYD2
Received: by kanga.kvack.org (Postfix)
	id 2507E6B05B5; Mon, 23 Nov 2026 04:33:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F9CF6B05B6; Mon, 23 Nov 2026 04:33:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E99B6B05B9; Mon, 23 Nov 2026 04:33:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D0FE56B05B5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:33:20 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 448D1160805
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:33:20 +0000 (UTC)
X-FDA: 85465870560.11.14BBD43
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf16.hostedemail.com (Postfix) with ESMTP id 75C56180002
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:33:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=xvRypYD2;
	spf=pass (imf16.hostedemail.com: domain of zhanxusheng1024@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=zhanxusheng1024@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795426398;
	b=m4v5MSVmk33qK0e+MZCxBN/HTY9GKku8exfmhofqSevQWqIs7iGoz+rijbn0LmHDqLsYzn
	WmJzfl/mlwPbDW3q7GIyCB3pTQHphLSrWyg++qU2LEoTxU6xbZ2t936zc7RZXiIv4PN9v1
	dDWdXfzDIwg4TV1kDlp7bm0wCEZtGnw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795426398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wQEceWpJaNwe3YlbGEbBWviq5t+274UXIF9GsChx7NE=;
	b=HnCqOhDCxGqOr0R3UWOt1iQk4KIAqJvGM4RTVR+1tlmpefMC39DptUX02xsm3f9Lr51sHs
	8kQKzj+zDmtk04GIuBx7sUxkg4PcbsEMHAKj4k6btRL7DwKnG6DPurArwvj0rDICefJTnA
	TykLIiw0Sa8k4GWmrN6BFB0WzoGhHWw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=xvRypYD2;
	spf=pass (imf16.hostedemail.com: domain of zhanxusheng1024@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=zhanxusheng1024@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8b612fd74e1so964282b3a.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:33:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795426397; x=1796031197; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wQEceWpJaNwe3YlbGEbBWviq5t+274UXIF9GsChx7NE=;
        b=xvRypYD2aJS3NUsfphxUW6hgwGgSXNyRXiPEGRnO9UWkYeRNxa1doRVXnPImRDNdzB
         Fw54gH6cNfdcCj6MxUS5UEF2UJdzFZ70BW9B+MkeG5DyhHxdp1turXJ4qGMJpZU05UPx
         CyM4+YuWzr6m6VeCEVykkTT3+PbE0KnUcbM8w5yHczbJRewckppTm/+uw8oXsMt0aX7K
         100G6+Lt77PznEUi83DeQecLONY81HT4xBx2Llv7LGTSxb/NFKqR7qUcQwrNztoBPi5I
         go/rGH8Ms6+oAUZq3WPG0vQR+pbCsK6/Af92HYISkcFZrlrGCkZOwKCeNGFQ0H+oyhHK
         BEmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795426397; x=1796031197;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wQEceWpJaNwe3YlbGEbBWviq5t+274UXIF9GsChx7NE=;
        b=cMLubUSRTdVmxsBahHEi5fdQcLiHq8YU+SAMb6TRt5J+q/MO3zXt/XtDv8eFEs9p8u
         WPPURml1S4byWnIIPx2wuIL02Ji5yzP6Wz1JppCsWPf43H3WaYwfHAlYHwxw641+qRGm
         kVGAv1glL79eb3RhVIfkPMiMtaPz6TGkIhlFF5MZSvSs4vKW7CnLHgCuz7DI6PArK9PC
         XUByvi0Hltx7fk49c6B6ZBU6zkQWGnGyl7WbC7W5Kz+yq7FkJunVC8GwxWiQCzSYmVRn
         3tMbdNPg6KBMYz1kS+7NSDPlp+MOO6DkilJpOV4xDBHh3hAJrF6EFsCWRvwIvDr+Asah
         WHeA==
X-Forwarded-Encrypted: i=1; AL+hErEuK5KamcZvlCCxey5K71O04Me2qFqxx+KTVyEL9kk1otyRiHRdRhreTpmZAo5OLNK2rNV6Qbyacw==@kvack.org
X-Gm-Message-State: APuU4Z8kBrNa0UHP3vIjIcTEPKRS1R/+y3x3e0I8/A24bhHsO/tPZcZZ
	tgc6h2xKYgilTtAkvCEGyczddd92qCo8Nlh6ouI5AB89j796bPfbtdOd
X-Gm-Gg: AZFdTZdyMVl7bKP3aOlflfWitH2ke/x5kRZpHyHPCVI4YBKph7BaSd2MEMg7reO9gHx
	qR2S0gtnrkAnfEgFwIPi5ByDGmKeoHEeo/A+k2/Bmp7c4KxTsokmrR4ddr+SUnyQghkXYYQm6AH
	jnFc/OzC8UlTXhlADhqc3MJTyQOqiulkI1tiTB8lPILtvgqXicogZn2ReO50QWs967+a34Wg/cp
	EM/tO9vM+lpOPtMeHMG9R48xx6EOY19cbjUMLNiD2Jmg+8YiHWvDdh+wsXt1yG8EHLM1ditozFI
	HZJOTJUsDhn+QVoFTEHvoqp6nk8ElX0KqV/Ynj4s4r1S9O0d/PLxZJfzMb/C9pWjnfKR/wCl97k
	PMB8YCpW+UchB1+FIZW63TQv4MOhbmSH7eR8Ri+Z37zVpoclBd6n8A/xDVh8TCXNpi3T1ZYnxmj
	kcxJLgKbK5DIDJxLnKMXGY724Yar8/Ozvfc9NrcTuJKJLTXWXmWmrd7xU4IYhgwPR4YMXOQlc48
	eaVX+eWtYj53f+2J0E9qtO+OtYh8+uXc9TAVnRePyfSTJYsaTJ4VPFtg1VMaRTcaVU/TYvQWhFi
	fo09lK91kV1UiW4SPwLc/BeZgUQWbZsYJ28hhSETsEIIKw==
X-Received: by 2002:a05:6a00:2ea9:b0:8a0:3685:239d with SMTP id d2e1a72fcca58-8c8793b8cf9mr9741966b3a.1.1795426397070;
        Mon, 23 Nov 2026 01:33:17 -0800 (PST)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c873b25bfasm5225369b3a.46.2026.11.23.01.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 01:33:16 -0800 (PST)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
To: akpm@linux-foundation.org
Cc: hannes@cmpxchg.org,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	penguin-kernel@i-love.sakura.ne.jp,
	tj@kernel.org,
	mkoutny@suse.com,
	chris@chrisdown.name,
	cui.tao@linux.dev,
	linux-mm@kvack.org,
	zhanxusheng@xiaomi.com
Subject: Re: [PATCH v3] mm: memcontrol: don't miss processes whose leader has exited in OOM scans
Date: Mon, 23 Nov 2026 17:33:10 +0800
Message-ID: <20261123093310.1733660-1-zhanxusheng1024@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-227786@kernel.org>
References: <sashiko-outbox-227786@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 75C56180002
X-Stat-Signature: 9n83387c6a9tposq5yjrk8o3fh3rj71q
X-Rspam-User:
X-HE-Tag: 1795426398-192132
X-HE-Meta: U2FsdGVkX18QhmL7Qj/Fr+3Rb6VL+6m7fhV5PJGMGkC3AKKc7BKsZVA7fQJxxLZczApioS2Hr4LGUonZGHjGjHiiauYHaTItL9VZ8iYCw/suaVw/Kq2Aoc9LNL4InC0te2I2BRHruL30+mhorXPGI22ri7+CHGNOaVUrjE8Cpp86/O7OPX4kPOvPnh8HvWeY97k6ShTxjGFPAsxNDyUJilfhWGal7vHQaq/NhF4DB7v312DTXaLdJ9dtHhb3fu3J7WmkOz18tVyVlr8QlJ21S6PynbsKb5dn6B9pyQ+KFGxquU7cS80OCDJYZimT2NMxs6pdmC68VU1hJBRChAm8LGnaXmHZxTelWP+z+iHrFEOpnNRIiLF38PEj4nESG4kez670a2hkSQOU9pSrs96mbLnUrOsLF0y4M2/e3u3OLLXydfgpBijnXxAfobgTXjWGEpzKRDkCaIP5ymA3oJs/X525LRv+HuksL6MSQOvephfEYvay+otqPj0hYpOk65OMAHiNrH/9TATU7uwGpRvqglnYfl24gTIjDH0WDY3tO/S3cDJhFA4enz7Onl2sXMud+K/8/7CNI3OjUp9U49Wm727nZ2G/4sQ1UXo+FNHVd+7yr0EVuuVScG0iCYyGuRxbqTyIaIhcGXFaE59ZhlblAhUUAoBwbZ2IRSXdoLygKBnlHtuBi/ZsyOd6UnSfgMAEWSGh3lJF5dJy0gRFnNuyxzelL0inyTZdxrWSM5bElT8nvYJdSu4GBm8kDvQdQW3MOJxs6Ms6qyDtAnn8moeBkqpy0RoMyj7zjW96/gfY2spYaQBj524/92cc5FVbsSx5E+aJGsS/dpqhnFa6zNiIkxfrwDVWmwm0nW3iTihCEPt5h04wTZ2C9tseBAEjpgY9KvH7cCxGoGdaTrUoTQJuQckjFcUdVsxMICgKIMG92xYX2jQ3qqrTXWhA7B6A3+DUFpm0ELdoyn04z2es3fA
 azr270cm
 Saek6RvZEhlnXDhKgpv7+9U2qEFWeCavKRMY1W6HvICJORFuzmSbdGBbmlNuHWgQ9tbVuLJfuZrA6GbFdoDEvDZiTf48kBa8ayCTeOlSzME1kklMtPg7hY2avhIxpQy6JiqlkRgmRKAVTSsichxNqqUInsqhowMlSpY9c0GhSxl+OYuOEMfA/TidoIDCnUzKzeQMp34RyDHiYh5Z52z/vLsnk5CKSipO9A5tHalfwDSsuEaam1jWWHc+z4pNUykks8HNongWtYxXtlDpE5Cl69evmCuRWJvMpnctXz8gnEHU7xZLgpOaLwmzoN1HXsAgh+wy1VX0JVKheKJX++Uq2ChxkQqcknDpSL0WLuqyFTKD/1ikW6whujfaWmfuOk8gRGgpBCc+WFHDES8Uqr7hymtUM7gno26eu31PTZrs/kfhJNi1K8AD5yQvNv21KIx9DwqPW502VQ9ACsMF9+E3gbFE1i8sMYsJ4Z0Q7P5qv9j81QeiwvWUo7nfKuUwBs8KIOiDJcsKHZK0Bu1dCZZ3i/kH7kYC2L6mATCRk4Z6pdZnmOHy9BQY12rrspa9oSu20+V3j2f3SShIzcLiodkOvfN7UIvSqIsOmOlCjTyfzsp3LaTZTTIk7Jt7ICK3XeAgZheis
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 22, 2026 at 07:32:46AM +0000, sashiko-bot@kernel.org wrote:
> Can mem_cgroup_scan_skip() expose an exiting thread left behind in the
> source memcg once the migrated threads in the destination memcg begin
> exiting?

Yes, but only once every thread that moved is exiting, so the process
is going away.  The source scan then either backs off on an OOM victim
until MMF_OOM_SKIP, or selects the exiting process and sends SIGKILL to
a process that is dying anyway.  Neither kills a live process, and the
charge is retried once the process is gone.  Without this patch the
source scan sees the left-behind leader all the time, not only while
the process exits.

Counting exiting threads in other memcgs too would close it, but would
also hide an exiting group that cgroup v1 split across memcgs from all
of them, so a concurrent OOM there could kill another process instead
of waiting for it.  I'd rather keep v3 as it is.

Thanks,
Zhan Xusheng

