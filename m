Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01B38C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 23:48:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6B856B00B0; Wed,  2 Sep 2026 19:48:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1C1B6B00B2; Wed,  2 Sep 2026 19:48:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D30D76B00B3; Wed,  2 Sep 2026 19:48:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC7FC6B00B0
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:48:23 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3CD801C1E55
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 23:48:23 +0000 (UTC)
X-FDA: 85170463686.16.1871612
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6EC10140003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 23:48:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=TZYaZ2sd;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788392901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jkgrm/ILoyMvWJ0vGraMeyhwgPKQ2+DFDrLrUyj3wEU=;
	b=dQKTI8TmrFTq/yWaQccdoYxjqieXBslXtyHFKNvpTRVLgVogWcxmE0BH8IYx62vhQemzjS
	sgb2t99ctWd981xV6XdxPn5Yu3LZRIypxxLMuJ3EvyqPzc2h9gKpUBwZeTE2rTuq1Dm74H
	G2h6mbKdIvRUT4sZ6t9lgbX4d1af1rY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788392901;
	b=vWi3U6VwnLwtqKkl9MEzrJ9mZ3LwsZnmOPoeXRSuMEX0k7Yp5rM5D+7PzI+v3X+AuFKAua
	jGt0Em8r7YtF0k8MHi31jzdTEF9kafXQ9ukcKx9b/YyQaGeXbvGPRbyOrmQsJdbmNrW7MH
	a4p7i/aUQZZn1B5ul3j0+oZuU5pTaSg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=TZYaZ2sd;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-529a1ee0e62so19058081cf.2
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 16:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788392900; x=1788997700; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Jkgrm/ILoyMvWJ0vGraMeyhwgPKQ2+DFDrLrUyj3wEU=;
        b=TZYaZ2sd4hrWGH6MottX/ZVVJmjAIooi7ZjO8p290eEPItjLMqgPN+zd2ufA5LHiRC
         C5vG3e+JFcur9qoL1pwGzvRgCNqStJOtAU3m+ittIsl8hnr2o0bDJNMSNbmLHxDSZgmu
         SYUFpHyi9wGB3DH2wYLRXAUUzQTTdL6oJvCPOLf0woRsqE6OXHdn/SH50Xea7VqPiNOs
         B3zl1lQlMfHU6J1hwn2LCbZnBG+E+w+jam4Bms9b5GRRRCUIktKKFklQnlfOgeX/z6E4
         siauey+LpNruXo70WnnoabBqMf9rSpy+Odqe/sp9Z6FDtmgtZlyJXMHqEHwQlYGbJnaZ
         E/pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788392900; x=1788997700;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Jkgrm/ILoyMvWJ0vGraMeyhwgPKQ2+DFDrLrUyj3wEU=;
        b=CUEfzGmSgXKHcTZmQ5NR0KVIGItRHOBTAAXmhfeTujvnhCHAKkiBkKl7OrBJEkODkk
         H4ELO5yq62dEPkSNAobUX8OuzMdY8pjQMy83n7LsRu8x3/P0anuAF8dfTTYtCZmQyqyH
         jCVLgQ2U9X4Ih11LmC4+aEQMl84hM7ho5xSytIBzfFJ7VDBrM+wiOGwcrQDx5yWNGV5f
         bQhzITAkjRuDm/0uNKuEE8eXdPILz3h1/mhlSPTZgXOLc9lQqwdNZKCLWKKY4grWwdV6
         KPcD0cknaG9/YRV2cf+ocYWlxRyeWe0bkdE32TKKSZmFwmCw6UddO38/RnKMiqUC+7Ec
         gEVg==
X-Gm-Message-State: AFuF++kZMfVNKgF+GuppUsoNcrTf5APr2c9JxfPmr9VsK7iXJ7Jkfrbb
	GgfrSVV/ZHZDTFX/nadf692u2rtfoXrx/3CwUDaYaR7bOtxuTYl8By4j1UgIfRwsypUisupooUk
	+ZA/DZWk=
X-Gm-Gg: AYBFou2iP1mHNO6VnuWtd5vyVvvlPVVFNPafMoqweymAedN2YIwavBmS/GXumNbXaK9
	kbv3kHQlsaFMIDkoqaPUE6EiKlZLGyj2590XR67uDBQfdl0O/o0pwL4UZI1sVL9OAqOvVExWTS8
	u2JJZNTB0Nr23fhWaeqG5uA+DyuTUHQZPE0XMQvMRQxSCcNSoxwPixU4jIg8XieBYNDg43Z+pa3
	5taTdFaCBUvE2hGX7l2VIbF6vq3V0KQXe4YSyOwG92hVj7Xm7SybioMl9PnfJL9++gg+Cqj5ngY
	vAktrV9qv8VosaFUwUqvKP8wJj56MLClPUffpRJfgemj5LVnN5MFWFgcr3+Lpm+0Z+lvWlM+sk5
	rJYsayiQHimOVVY+OEjNMpJ1UxZ0nMYMSx4DclcV+2Hzc2QstKkt7V9iuzri0MSURWlKBtuSbTm
	7X/7fg3LowywuJH2MN5EQY8s1/G1B66IItIyhZy4aMrEeWErfpRun3FgD43tVMsXJ3zeZQdF2hu
	JX8mVc+A2fk1Tn6UZ/oLn8Py3uJ42rX+HNA2LChK8Dw
X-Received: by 2002:a05:622a:3cb:b0:530:27a1:88be with SMTP id d75a77b69052e-53036d141b3mr104316971cf.30.1788392900530;
        Wed, 02 Sep 2026 16:48:20 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53033277f37sm31280861cf.30.2026.09.02.16.48.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 16:48:20 -0700 (PDT)
Date: Wed, 2 Sep 2026 19:48:18 -0400
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com, balbirs@nvidia.com
Subject: Re: [PATCH 1/2] mm: refactor find_next_best_node to
 find_next_best_node_in
Message-ID: <api1Y0neGeB2ukQO@gourry-fedora-PF4VCD3F>
References: <20260902215853.156267-1-gourry@gourry.net>
 <20260902215853.156267-2-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902215853.156267-2-gourry@gourry.net>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6EC10140003
X-Stat-Signature: nb4o5m5mdemah7qg8hrxjroapbez7qyp
X-HE-Tag: 1788392901-434062
X-HE-Meta: U2FsdGVkX18/ew9noEUoQod3Rc7bjI64B/SS4MLuLGcZ9dJg5GpVfrqdN04yVCU5ABh6mdAgEStGyWHPFb2zp4aQ74zD7+xS6BwTzTNnn9SlxRwroPv+Wb6mxzUORfY1j5TgOGxaJfaMEMonoQuAcq8lLlZ5WfOEaRuJ4r357bpcoMwGPgXb8QwqYBC/x8FYd69qpj2uf/EZr4OpAi4JxB7HbMqZKgakBUALIEi1v+nlKBZC5Dnfq0Lmh5gwT6z0jrwRVe0z9KTB/1Ir1eTiYCeszlauAJVzcVhcc2e307doxzTqYBKkgE2QCVrb6/Cq/3cg+lR0YUfQhjyps9divNpWWdGsGy2l/9WWIPULc3bMe9H9ACO6AbQzcJlybu/2LWZUlBb6lDKp8ngaOOpJCbsRsWAHc15SnMszENDL+vZMNXkam9J5/zsjGp+uUD9RJ7O9eTgqg1MAeMT+9Bf3cRrI+l+kjGza2w2qe65CJQE+O0WgbB7mKRGU+XPzgmn/YJ7aVVRlQp4zvCTA9YoouYfwDuNRjIEOkfFfe/R+OuveA4XBL5Mjo6CGYlJBRgy1h5ktQRvauOQQasDhNzdycJr5fTehPmlaRw4Ipfi1sDT3bRmOHoMvp4f9SyWxZxFsp27JCtVQd9NGTkYCTBfSwshp94H+M7nYznSPoz2/KOz7oCWiXDKC7pyOoF+aeApxr96OGBsuINKDdYoYFjOeRmJ/b8LsxAVMBv73Q7yNJG5cHRFmUIhLOFjQfAoK4QUswsqlG6xqm3gN0rTdgAZ3WfATBUbrrGYQAIGqDK5Kw9tl6Ea3qCF5QZH9BdVNcTXwoIpTdC6ClZfbTpFKtAeVOY5L9bOxcCRN4TREBKbz/Ktwq2+eqf911+moA1zvrhQiGZC0By0h80UwZkeYH2b2dTgzw92TjQkNAAAGCNw90jRoFqVFaHb/hkKVx6uvOzu/1rq0kgGGLq+Y76f+zRf
 lPGVNHlV
 QEFKuHS8+oQJhGpALxxT33rFdWy7vRYvh2ehAN21ZKuydilU6ZwOMa4MOJtUm6JrJ/olJlRmb3++yDTwLSzu5A8mgZ/C86Apv62H/q52LRtwNtOli4/4fXrcPI3L8zHXDiWGjAD6Lh+b7NNJ7zaEUjhDGhM2fgS8w4jlV06BC4CyzOUJLj1HHwexMZKR3HOTmtpRptjZXDKnWYcVu7iFmC73BvgT5vX3Kg7gzkhhJhmpwIgZlsXNv425wDiukbaYXPP0nLMkUBtz04gkNhWRLrm+P32qGL5cwvkFFZXW8BfNX05H0zX+OZWuoOngKiEj9Sin4cZeS9QEYNKeQXqk2R27ouBvnvtJqoxAnryTvFzYP5REoBE1FMiZ6YBpaO9TYl1r+T+WDoU/LjBhegQPRnrj76Co7yt+GNKVEQnNXgEr/I9wdLBTXWDKMa0xWak2gp12SgTqpsNWVzG6Jy55foIaIlfRAB/4M2H4vcDurlCG7nKc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 05:58:52PM -0400, Gregory Price wrote:
> find_next_best_node() picks the next-closest node for a fallback list
> from the full N_MEMORY set. Refactor it into find_next_best_node_in(),
> which takes an explicit candidates nodemask.
> 
> This enables building fallback lists with non-N_MEMORY candidates.
> 
> No functional change: every caller still selects from N_MEMORY.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>

Just realized this should carry an Ack from Balbir

Acked-by: Balbir Singh <balbirs@nvidia.com>

see - https://lore.kernel.org/linux-mm/62bf02dc-dab1-41bf-8204-eb3566628b93@nvidia.com/


