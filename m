Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB7F5C9EC94
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 14:50:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0254A6B0088; Mon, 12 Jan 2026 09:50:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F15376B0089; Mon, 12 Jan 2026 09:50:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF6816B008A; Mon, 12 Jan 2026 09:50:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CD2456B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 09:50:27 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 71B9E58CDF
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:50:27 +0000 (UTC)
X-FDA: 84323597694.08.8E51084
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf21.hostedemail.com (Postfix) with ESMTP id 841F41C0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:50:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Ig0lxIev;
	spf=pass (imf21.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.44 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768229425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cnr4qVR4p/JzbP4MQjfizXV7qnol5umPh39xUTusdVc=;
	b=5XAIhF3izeZMbN0hLsD9TJfYAteftEQ/Oz/rWeS/BOydaUc5RecRmJiKAm1FvFIYTuxDpn
	9Zwhg8AHNiDN0Umhq5DkExr1/sbq4jCYl92U8JNpQgSfTGA1qwLq6q3wPZg8XmKOsa+qT1
	iVosaSZibqm4od0WBcrHusT9tAaTY+k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768229425; a=rsa-sha256;
	cv=none;
	b=TAbs7bWAKl1DdNPuZnj7RD2amg5eGq3wY4jHHR96vToeZ4qovBDV5xl0CNpYA+6X2zDnTN
	y+x1DjmhNULT8asEuVv16VZLMD90HT5gGel8zeKPZrWhrZhBKeyK3IUkrB7FOIl3a1XPau
	WynS0bq1hAUIvZF9JYzA2e8GlQn58Mg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Ig0lxIev;
	spf=pass (imf21.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.44 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-88fdac49a85so69258046d6.0
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 06:50:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1768229424; x=1768834224; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Cnr4qVR4p/JzbP4MQjfizXV7qnol5umPh39xUTusdVc=;
        b=Ig0lxIevTc0XraJBBeS958Zltdn1couFBRsqNoBo7fMytzSyxMsoyN2S7AV8KNvZSK
         FLZq05wkArCkYl2cRchXtJGIfD4c/Yn+9Z3TcxC15MMDXzs9GeRz6NB2TjlhS6WaFSpw
         D3uxOjGT+FFegOpB8AGJ1Sn33Ylcd2f+ie3JB6v68TgnVG5Qwq29qbolL+1Ztq1d2MPB
         dhci260coB6iw7MlSAmUfmj902EefFej4AIxQhhretxW2VY60bJEUZ7fLmpcBfpMoHq8
         ZgNbWgmb9NzfrtN4MRKe5+zkjDjW/11x6J8LtfOwOh14kkT92uCU5jkoirTaFJsGWEeA
         OQ4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768229424; x=1768834224;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cnr4qVR4p/JzbP4MQjfizXV7qnol5umPh39xUTusdVc=;
        b=Yy2vX7i0vhxZNpinmp+H1rmsEhQ2F94BRcA1384R2uUFsde5E0Pb+Szik82McO0jNW
         7J2QEyPSiuG/oMIx3j27Bg6s2XRBUvCmQzxWpneWJKi+RV5xKN1fwgT71YOjJQKVXK3B
         umzDUCA5xmNfHTr5befdEri1pWboG6HQ0+55mD3BjZ5JuG6KChxzp5LANbzLiM14SRhS
         cO0IKlb9PIY0yy57rOWNa0ZZ0rzAkRNfwYafOXr0EliYKhdtelEQ7oFXnJytASamwngB
         +YWA6QYijrjl+Ld1F4m4c2HMWKTYfMfZzc+0U3yHOowXjKmlajCn9VtcRD2vKzyX2wRU
         EUzw==
X-Forwarded-Encrypted: i=1; AJvYcCU8zleGmJJu93fvS2AyfMQNZI0V9VnuBw7Yea1txweufDTOCGWgz6s36t/ZwEKUp02BC0saLN7YMg==@kvack.org
X-Gm-Message-State: AOJu0YxmU54DFHc/gEJcpCfNyT4r1WO+1OwMHkQpVgwOzr+7dPwanPsG
	PJIbFyOFNX+UL7V2HLEk05iJh9zhP4Uqd+JEKkT1AjNGSuPohdTLQyvogp0k1niUvg4=
X-Gm-Gg: AY/fxX4wKuacK1JefCfECjSzhPsDsvypT11xZNeDdWEM7ZoDd0qbE/VYTl+pF3ol4jv
	Svtxa/IdaJBsh4T9kI3/Z0W9F398rVTJaa/FGSRgSJXSXF6MgAwrUTMtNMbu5ldLERRlYhcNsQu
	CxaB19T5/9Za8iJWbp+K0rcxNju0p9FVQxbVYt+ti/oc48/s/R1zgfi+WmRrZiq4HWHUcSQWwGr
	DRejsm/LVI+PqdcC0Jr8MuLk1I0PAJauaPmTEQDcI7hbscnnfFPw8qHTXjcGHOUII/m2E762dli
	zFmJye0ojrCiuH2EvRjfUjejVB24V5KRzyUuWb/iRX5zvNdCi5xQVx0qWXtTD23BD+jEb8JOh4V
	SUkcbo4EeRP7HfaTH8L7Dwi9CMoSfx/eiKFulqim89rsFfVpmweldsG7GY82xPZVQMBhPh8BRz9
	aJtwrNO5RvYQ==
X-Google-Smtp-Source: AGHT+IGBr6wZA0PL0dSsYUFTm1Un0FAtEx8rRBSFF04sT2EzD4Qp/fT8gC2DFyR28E5Zh7N/xNhuuA==
X-Received: by 2002:ad4:4ee3:0:b0:888:4932:1476 with SMTP id 6a1803df08f44-890842fb0efmr257342796d6.70.1768229424351;
        Mon, 12 Jan 2026 06:50:24 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89077235411sm144888136d6.29.2026.01.12.06.50.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 06:50:23 -0800 (PST)
Date: Mon, 12 Jan 2026 09:50:19 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Yajun Deng <yajun.deng@linux.dev>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: [PATCH v2] mm/page_alloc: Avoid duplicate NR_FREE_PAGES updates
 in move_to_free_list()
Message-ID: <aWUKKyBZzsCBELLi@cmpxchg.org>
References: <20260112121614.1840607-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112121614.1840607-1-yajun.deng@linux.dev>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 841F41C0005
X-Rspam-User: 
X-Stat-Signature: os6fqpi7f1r1n5gp6rqz5fa83z3s1qet
X-HE-Tag: 1768229425-923596
X-HE-Meta: U2FsdGVkX1/jA3nXhNoP1oKVEeMh8fpI60MyUOBsaKTN+9VobHT1qivsrLn56V+p3Y44CcBiiEetvtdCYGDyNZQmorjeCXXREAwlY1vR6GjNGvAKkhg4lzq4zK5B5V6XMsJBArlPC2vcTRpBYqkJSqmkyYeqt2fY7bdJKPQSy2Xn8cnx6n5BO7LLEJSlxyWIJfRyJzVUxlGtSjuvQ27GCdW7CFZ0YSTC7svpeG5RcFDYq7eK1cej0cyaqF8k4HrINq6/vVEqZwqU6rLIZ57KvonfUSQHYBV0dZZYch1UXUg9M+rrB97wzRdSy03KnGgTDKOtHIAEEPaTH6GgRlGrkv9BFg8Y+K1XsykxWeJ+0q3Xfzs8D6UCtDydOVQ7TV4T8h8GoLMmoX26AXTsgGV0DkibcgVN4GpfnHuZeQKPpZWfNpG9ujuBQFGSZDCOcwmdFQYL+aFq9eJdxcDFFZ1/099XVgYAXo8HarP/AXwzvHogue/yM1GgyDvnQK+wrnJqAMCNiZOYo/ZZpHPXNcgwQ3T5j8KoTUp8ZXw/TTWM3nIjVwJJsJsJiRjzcTYKCU0h31ONXlNtDnJs93eSHLOIShKwEIjTUmcxm1sz/JPfOqrdMldLT0AT5FfMpt4ddhYV1NBfaUsFc8xxW/RcAWoIkJh+s5+FyYDToAcS66EkzJJZSVievhpbx+IbhXc/JYV3N0d/WJB33x4bRgWMC7Zk74laQ4hJc8oPKomMsEV+RlDLKUeoGIfR1ZVoRBHHUl3YQptWVHV080FaCVUzNhQecBx4K6IzemZ9V1CGXyeUiWLbWh1lldS69aeNDgZXo/WUJ59m1Jk86SB6JkBFMnrl+jPiSxKXSCmQg4xb/aC7q366ErVf6CFtplxj708VYqStVWJKGjsieMJaX20U4eScLd2sF2HVzjvyucdGXIAsCiPgRrZO8whpytQ1XQnRz2VVMAfNtunRmPkQqZYdxIZ
 cvoy/PYM
 uoIWD/5dSTW4pIG+jE2f1DYfOFoFptwnV0kNfD5aEjkSpDKHESw1Y5ZG3ekqkO/ia5Y5Jit/SKQPpsTx3KplcxhkFwEqHbGyVzSrTFyiMzaQ/u0QDuSrn2QV0SO7quf4gxEItAOnTekmP18qW8LhY+R37YszI832RqPHl3YXSPASRSUasyRd7z/Yz2OM2pSnhhcS/OLtUzw5icWCQ2mPiRnLOohEPgk2eSkJDHJood43HYg6gsnBFjL2FSC5RDIVjoMVM+z9lD7C9SG0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 08:16:14PM +0800, Yajun Deng wrote:
> In move_to_free_list(), when a page block changes its migration type,
> we need to update free page counts for both the old and new types.
> Originally, this was done by two calls to account_freepages(), which
> updates NR_FREE_PAGES and also type-specific counters. However, this
> causes NR_FREE_PAGES to be updated twice, while the net change is zero
> in most cases.
> 
> This patch adds a condition that updates the NR_FREE_PAGES only if one of
> the two types is the isolate type. This avoids NR_FREE_PAGES being
> updates twice.
> 
> The optimization avoid duplicate NR_FREE_PAGES updates in
> move_to_free_list().
> 
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> Suggested-by: Joshua Hahn <joshua.hahnjy@gmail.com>

I'm not a fan of this.

The code ends up more complicated, more lines, and fragile because the
accounting decisions are now spread out over multiple places (again).

Is it worth it? move_to_free_list() is used in page isolation, which
has to do the accounting anyway; and migratetype fallbacks, which we
are trying to avoid as much as possible. So this path shouldn't be all
that hot to begin with.

Simplicity & maintainability trumps here, IMO, unless you have hard
data showing this is worth the pain.

