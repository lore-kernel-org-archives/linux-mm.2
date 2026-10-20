Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F383060A3831
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 15:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=H/I+qvkr
Received: by kanga.kvack.org (Postfix)
	id 14B6C6B04F9; Tue, 20 Oct 2026 11:13:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 123026B04FA; Tue, 20 Oct 2026 11:13:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05F786B04FB; Tue, 20 Oct 2026 11:13:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA19C6B04F9
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:13:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7389A14021D
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:13:47 +0000 (UTC)
X-FDA: 85343349294.23.6F67869
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf26.hostedemail.com (Postfix) with ESMTP id 96CC1140004
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:13:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="H/I+qvkr";
	spf=pass (imf26.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792509225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E5glhVrwj86spGywngXr0iRHfq7xQsmGjowFr/WZU4A=;
	b=VV/J+EqBIhhI5/MPE80FEodqNeVD8tZRu3wHy17bcev7fXQYtpMQLjxRfHdAYIaxkhwkAH
	Mufpiu6oGSPfEzui4hagOfJE/dK0By2JXkljXu9qMD4UCSev92RBQB1IRudnsVw/nnZUR9
	6E0cyxiUxRBut1qjp3QD5eBRtiXHupc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792509225;
	b=1ZhUl+MgVEU7dpm+DdcS0QDS8kOfLDyr2q0JRhbDTXJaSNaJPLRIKiia7LUXB1i+Z/9qfQ
	cHrYsCb5iL9Z54/DleD0yAVPpLWpDhfW1dtIA3BKX/VVuqvZYWqvu5HY37MrgAesW5guqA
	tVgTw+Q32aEh5hrU3eT6gUH3C3omzPo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="H/I+qvkr";
	spf=pass (imf26.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6b3dc272dcfso2122025a12.3
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792509224; x=1793114024; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=E5glhVrwj86spGywngXr0iRHfq7xQsmGjowFr/WZU4A=;
        b=H/I+qvkrkxbkEvLK6JgM4L19DUkSNZt6lXSQC9HM3TgxHAoRSt7xS0XKtSfE2F6coj
         8O6GrvvUDiRZx6di1c3e3sMqaFKtO0XENce2ryhexPgk+O0iTK6dTbadvUKxZuir/tMK
         mvJBY24lAQakhSJFl4kS5LD3AQRyeAms36a6xMkUcxDjA84paMXIkmxaRl8bdYcxlOZ3
         +kCEeAAnOrUMX2YkxnYJm3gsVaf/2XCU34gvgOBG4JqK48FycSdDfRtzYU0Gkq864hSb
         xN/m9kBazuvbgMvG1854BrWFc5xqKg8HEIkPzS2flszYZWOq5kdHsSFEQJCaXNpt0y6V
         d7tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792509224; x=1793114024;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E5glhVrwj86spGywngXr0iRHfq7xQsmGjowFr/WZU4A=;
        b=EDNbqHGvGDyDTk+9DbkjuNsFxF+3/dCV6l6ldm0yc0CVYh9XgKbd7rDNS1pH8JztlH
         vAy0WKs+BULRigc9IQNEieMruRheyGm9ttfs4pIqvHGjq/W4CgJYsamwP1CJ3AQXEn8z
         5gqf6CLntrJ1xEw+lM1laQ5fkur2MHJpcD+x4QrB1sCvaaTCfH/TvsPbVdHEHDmayScN
         gsjAJtP/WarUOscGLrovgAMCprI4pvM4VdNzqnYB37uwXu6pRPa4ZMitd74kPd+ElLAu
         bSrVOv9rRFlxUnye5Vh7VtOf/UjqFC+hJ+DbuKVJK+9SadajTQZ4mXR1fCPTn3n3FqvH
         56Mw==
X-Forwarded-Encrypted: i=1; AKwUvBynx62iyh3aNkFiFpFo6jG93C0jijeziO88NuZtJrGzu1XjlMJpULqtjtbDyNiE4VM4IQbbvpspgQ==@kvack.org
X-Gm-Message-State: AFq9FYKTvWYPjensBzdYOguC9ieVp62s+4OCeCtiS46YT9qDOByC/V1Q
	aaIFGlbMxCoYDShLkUvRvK2JNkqtHCfdGYVK6UCq0l/UA+s7IezW3lnB
X-Gm-Gg: AYBFou0XnW7k2bbBFUqUO1ZZf4htMgFjHAti2upbWhnsM1Dc2P4nKHenmkAl7kcybbQ
	LUsq86nO7iZ0ePhiemQzXND6xdplu4Wa65/yVPeiiCD9CqvuxrgNOmpAbpOjIHvm0kjTdOa/6hv
	agsmB+Z5f57jlSCB1dAbwUCadTWCH0G4VgNMRHGkY2g3CH5hodu2G5aKMmC+AaTR6TWBUVRklhy
	296cgcKR+kVkq1jKsgru58OkKk19FKgHL0br03bPI8rU3x2CV/gFHvC3QueXCmG8WPCh5yfimbY
	P0swS1XVgizQzChd0xu7cp5jD0NsLVjU0KzWN+hYgzDLgE6DcrbCqTFQGPEBubCC8aHG6eY6T2p
	FCuy6dWENwS1Xju1ASt9yGZmzD8P4bCFJqVOJf/8lBgA0lSQnzcfRDlpX8tU97T63EyYE6GEPBH
	/6TFu5gcu2aih0A60xFFSaikrKaLkggcNQl54=
X-Received: by 2002:a05:6402:c549:20b0:6b3:d0a0:3743 with SMTP id 4fb4d7f45d1cf-6b3d0bed948mr3136938a12.7.1792509223944;
        Tue, 20 Oct 2026 08:13:43 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b38a1b285esm5091427a12.8.2026.10.20.08.13.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 08:13:43 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Tue, 20 Oct 2026 17:13:41 +0200
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/vmalloc: read vm_map_ram block regions from the
 requested offset
Message-ID: <ateFJYagAJjvN8jr@milan>
References: <20261017125244.b2d7134fa9697b2982cb8cec@linux-foundation.org>
 <20261017231325.796986-1-nickolai@csail.mit.edu>
 <atSM69faDNgmLNVJ@milan>
 <atYRUyFHca-giQcw@gremlin>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atYRUyFHca-giQcw@gremlin>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 96CC1140004
X-Stat-Signature: xhka1fed46gm5rk36y1yso1izspztatj
X-Rspam-User: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792509225-388303
X-HE-Meta: U2FsdGVkX1/Gs/1WUmit2V3E9Ubgfz/FKZzRRePmrdhi9PCXGTgn+pcZTb24/1yfoy+LQBY/oKyrf/F9ssW4ufxUTwppLtBtFwY8PD2NnvtTgmxSVIqNaElgD7Y+wvFmORcdmrCZcBtX+Uqvwb7H34GMWrKCfsi1m/81HB58edMBMpN2znkuBGLaYJncbDTpPvSLAuZ8eZoVXyyrYoXm0fgM5QQA8PfzgxwdJPq2Qh9O5iVRkTZX7B1Oj9QQj5RwoeYpfixpL+QsAwzG4gJVYvdZ90BePzbMxqa7yULvdOTnQZMrWMRwS78b8h96t4kzcYm2CC8BrqnSOgE9MYJ8tsDPi9ExK8Rs8Nf641UWhDlTPooHSeUA9vBvfg3AboGvzR393GAUJtnODkieW7p7V/w+P20QWtvD6imn8rbckgH5rjRYuO9NqL0+pDkWgHJ94buKZ8xCS3orcG3Kdzvm6iB0lQUgUhNvCkm58oNrVaWICcAmCVW9mt6PfpGgeYeAC2/UgcNltHodY/1OugIZJwqquVUwNJ5TfFYAZb1Awbh5MEhc5h6d62JmQOtZzIPWAgmEhpVuIX0QoV9uFy9sNF3htuMSyKhzZh/DxuqTK3NnduPcnvZp7t/wRZU0t82YxDcNUesxBKsvGEdjDgHl0qMnykZxumGKJoe34KIa4q0fbnrtbgJhzTzjIc6iy2Cj4Sv4PcYypKYrrL2McldZZYzqHM2iBVFxrECQRAmsBrwrP39jHDfzIVWccwS9Dotrpvv5fkOO2A+OZx6fwHvw/hEUOimOmR1+5XRkXqe40qkUeelAEQsEI/7jH7el6LOetjZYpXG9IQM2wo0NEBQNevoxe+t6Odq6jvyRT2tcEK6e/ict9s+tDQaGzEIYCYYYa2qBU0uKaR2xSbdvTHp5GU7DjU+XCZBluCHh7uQLoobqJspZgA+ynGMRq6iexA2cGDEcR8sNPHhMPD5cdxc
 KgGfWNX4
 sfG/sI/810/k5P/+vkhqU1Cg7vWmv0HZxu1raWHKjjm6KhFrYBKshMloD1JLP3rjFzD37oDpFwGfYZ5gY8LymczGANZH7GFLA+lKrSTT9cfYDfaB9C97rN2vAEq8wDrXHBWloyzxqbRhIKtCujlJsA7vuyVcCZHjTxIBmkZwarDot4AZqZY3ewBAuH/2lZMqd1Gdw0RgQ8HrTUa9N5HIP7JjttjA8XaWTpEuCnCKa6oG41AEVGwxpMi5aw1nt0cPAdgZ5SmT8d6VBvLedHcp5w4pU5C5FrINzTxaaL+TpCur5luZ7uUHjltYE9fz7F4AuytMXN2xFhGkiLP3Pwx4lXCWpwZHSKFbCnkd8S8DqywRxIESBhoI+L+KO91UjcChez9fWnisgKdKJUIUCTP3teE9VWGcCZ2I6T8jQFMZXX+aojU2lTEESi8mxM4kbpWGACUlowSSUK0pVYGpXa18dMuFNgVWMt1vxRZNebkTw0bn7BQYo/GGIow/xY6kNyIi3Vi3p4/q0U29PQYo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 01:48:46PM +0100, Lorenzo Stoakes (ARM) wrote:
> -cc slopper.
> 
> Keep in mind that this individual is flooding the kernel with slop.
> 
> We should be wary about encouraging this kind of behaviour. I suggest taking
> over patches, 'discussion' will likely result in having to deal with a meat
> proxy.
> 
Thank you for the input!

--
Uladzislau Rezki

