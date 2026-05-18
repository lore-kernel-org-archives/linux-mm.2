Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 906ECCD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:36:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0400C6B008C; Mon, 18 May 2026 19:36:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 016506B0092; Mon, 18 May 2026 19:36:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E485D6B0093; Mon, 18 May 2026 19:36:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D32E86B008C
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:36:38 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8EAB092D69
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:36:38 +0000 (UTC)
X-FDA: 84782152476.08.6DCC0DE
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8E21E4000B
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:36:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FdrbbSYi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=leobras.c@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779147396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EuKoUSlpted0cuVswCczpcOxWTOTY5vOSmGOXWmjcNY=;
	b=e/RPRnBtpZwd+1M/SRX3XVmvkceNgEoQa9YOy6q5hdY394pGlxV9/YZHSyx89TIPLlGo0v
	DftfC5pBkrIGqtMwsU0GN0aBZMK758EKXlcZeckU6wXfN7EP37bmfMjKlwnP0gtu3mn6kg
	88kw1gk3t/IYUrcYiuLiZ9lykkp5bRM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779147396; a=rsa-sha256;
	cv=none;
	b=18P+Mgx+FcN8pUJ38PoTPqEswDKkKXk59OFuvbQLZMwHBeGTRHMemryXW5tDM2DCbS+HRy
	ei7N49cq52Z3eDIu6jeXhNxcvxr0DYLsyrMtWvd+xureBC89Ph6kzkNMzavQJe+SsK9gjD
	LbXMA0lXOA2bUFfNGnYWQyQKTTVOHtY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FdrbbSYi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=leobras.c@gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-44e1860558fso1708775f8f.0
        for <linux-mm@kvack.org>; Mon, 18 May 2026 16:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779147395; x=1779752195; darn=kvack.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EuKoUSlpted0cuVswCczpcOxWTOTY5vOSmGOXWmjcNY=;
        b=FdrbbSYiEs5TEJuKnd1KnkOrISwkKGEvE9a7SmFmU9LWIbIPX/Y9VcNH2DF668BBhf
         Q15iYuWPbvZMeFKIk+5/WBn1B8bKd01CrwfPIgmq+fgkmZMjzsvYO4EUUX2b5Q2U4QKs
         Ly5Bf2Q37pSGykjeRANJC9Lr2EI2QCQpyaADi6YUv32hdIlNZE3u4SRS7xfpfm/X+M2+
         vF6GwNsd0Q0mLKXV43VjRPEs3/HhZDpzVSd2uRg8Cxw2II07bux8nJNBttmzv5XC4PnA
         MFRKCANk9mxUerpDdkxuN0DSsIJKioVYtWk/P4vIdCpaEeHFwfCyaOQgXiBgolhYFzzZ
         wo+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779147395; x=1779752195;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EuKoUSlpted0cuVswCczpcOxWTOTY5vOSmGOXWmjcNY=;
        b=GHUxbyCvLvb801mOAdtQL8H2exGm8Ja/3k/8j5u3CGFT8iN5eDR7ui3/WtUvKizbXW
         ppF4hemCEwPe0+F248AiZC7T3NZrhwluvraI2wjP+MhOH2BDdKFhb2K15I/sTM1hEw2r
         wEGoTyI/bRS/uNW4ZNgC7YGMCTlx80p8Uf/nnZD4QF87BGN8OcBF2Qqv0itS3FFLThG8
         wlD8dMLC4HdkpyiJhAsDYKYXdsVaYf2tXuh+lvr4UwqStkJNJjWDBNFesTp6EtFvt5dx
         T06XrIxBOyAOfbZ7pkbFoNOD2LNc8SkgJ7xEACODmzyowLMIhRvdj9MPkFXvaeblIfJY
         IpHQ==
X-Forwarded-Encrypted: i=1; AFNElJ+bz8Q82M48YIYDAIydRQ4ix2MHHZAfDYvGTdsQSgpnmcoN6BVqCJSIJ8qe8vRDD3bCKYIjC2lMEA==@kvack.org
X-Gm-Message-State: AOJu0Yzd8fYDJJfcjKmg5AKB4TbfcxaqTZzFuBoE7ZYLmW5oXIYMpAT5
	OrHpFapkrvEi0hALoCg3Cz7R2GNg1r/jy/c/QFjkcNUJw0dagrBh2PGT
X-Gm-Gg: Acq92OFcFDXEjRk4ZouW7SJSDQen3YrgSGvbAy3uBPZNce3xmEMlmWsA+rr3uLqCYUe
	O6jKPtJusLIhp/iJKHbpBK1zrNiTfeXYpT2iabVWWIFznOolfLhUBrZZYYA/nCufL1k5N6fa7q2
	ATeF5CODUtV4LeK9G7cCFEVNzugpAx3Xd/s4zCxUEj8nvBs4hKA6vgkO7qTV5aSkLbUCF2f/cDJ
	/5Vb+xEbXotICiTwXsNJSx30bvkt6rAtixEL5Nh2D8b7LDyZlPekMiUvre6edFksPtxYujV6iZw
	unGeIWUT2xU6QuoXEQM/LAZWLOCLkFP5gDB7JGi8k7Ig5EwtScTJJsMwvxVtvK8PAWUCteoXdBZ
	B5M3uRoDf9v79/h+P5KSoGns8RpEJRtNvlf+V4ptLlRgXVCZ0B7Q4W+ptcYu4Cn/clqm0PY4FaG
	qX7jz8KgwLfDIciTrxOMPuIwANz5JR8rsH0nEZugrR
X-Received: by 2002:a5d:5f44:0:b0:449:d189:e79f with SMTP id ffacd0b85a97d-45e5c5cc86dmr26831119f8f.32.1779147394799;
        Mon, 18 May 2026 16:36:34 -0700 (PDT)
Received: from WindFlash.powerhub ([2a0a:ef40:f83:8501:800:cd4:5e2:9556])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da0a17ec2sm37690007f8f.24.2026.05.18.16.36.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 16:36:33 -0700 (PDT)
From: Leonardo Bras <leobras.c@gmail.com>
To: Frederic Weisbecker <frederic@kernel.org>
Cc: Leonardo Bras <leobras.c@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>,
	Boqun Feun <boqun.feng@gmail.com>
Subject: Re: [PATCH v3 0/4] Introduce QPW for per-cpu operations (v3)
Date: Mon, 18 May 2026 20:36:32 -0300
Message-ID: <aguigBraeANGjVMd@WindFlash>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <agsMqeTRU9MbzdQk@localhost.localdomain>
References: <20260323175544.807534301@redhat.com> <agsMqeTRU9MbzdQk@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8E21E4000B
X-Stat-Signature: krbfdzjxzngw1c4ed6apa6p9679irf8h
X-Rspam-User: 
X-HE-Tag: 1779147396-601008
X-HE-Meta: U2FsdGVkX1+QOGMIhiJfrSqYe6S/K7Pk3qnxP/r/a5YD/nXWSjUSERUaze+E14SCscJhn9vKT3jXrE0m0ixFsnBdiQqTDTHb56NXzuJDkNeq8+0T27iLew4QDYsvnZbbeDaVWI81qfyfpmVHWnejfrvKdU+WSQtaU7fCvnYUPiVCVGLKSgoFahUhb1JDDIQydP/OGCAmpuSpuF/YwcnMIB0bmBAhqrzTndqV0lnz5dH8wruyUMWqnr3NWd+VaoVbT6BDFoYJFK28Bqqnj6CESopYFu43UWPQc6R4/dB5SLWslA0sFfRyx+YdFN5skw2VKkpLGlu95GmGJUiV609xvR9bFdbzMu5DvK4jcflLld0LDob2J86QzIH2+IZGy7LHmBHSguBaFTgLO14xhQ0XlROML6N8vFA1zMDYS1WBeZjEncp82fEEsFaPvRBc1yylqlUm9UNULdLn4qNkBuwJhxh7GWcxEYMlA557iM2plprhmpIALbKqhuQLUUPZaAQ2gnnVYrFFKjwRKB4JyR1YzfqbWcDc3N0J2HDV3L9h061T98/9q56ZKcRUkCfI5TFKGXpCW4wVzRGWcyi7QTYnG6QCGGDSOk0BbtZ3KFw6TGiKpQhn08/Y6I8/Gad7nRXkZv3vhp3wTPd4frXkzekfN0WiXBiQT36tJtSp/WCABynCdHvQloV7zaf4mN9wKXWg53SIVuptxanB3E5OxQAqc3qkVF2B3G5oNbc/+kBVYUycT8yUu/qeK0T1h3ctF+qHnSRXLHZfgDfW9g7/G4TZGOqfPVS0S/DISRE9JA+xfjKf1NwxBycz8pdvKj0PS6nxF1gLyLeVapG4fRiIBtmQmpG1gD2kCciLU+ZEppXM3xDtmcASlaElBwRLp+K+CtYnV5B8K/dEAz4rAEXzMb0Kyd1sYB/JGWnRTTfho7VnPXY1emT76sN41Ae4R6LjS3YM/4Y0cwbZrLR33Gcf6+F
 iNa2GQGi
 zlAYN1669hK7eClhfXChhktpgGtj7KQMmCkXwb3D8f9eqjwNLqg/UQRljtasAH5ylgvbXyRFgyDZz+gDC1fEsdXovuC0yKBoNEgM04rGQw9YJMPHB94VCsCHVxiwngPe1U2uBYIF5oXli61fE0tnM7iH49B9uMYFhRidm4gOvHjuzn1MB4ecx5GTrpPRWU2D1jTRE1Pt1Yuaymgpc/q2D7N3jz/EEQdQe2H0hx8M6wbb3ZWBcx9UGOCqKUJeVBwyxR6ddQKGqIh48cTYtBkn8DlLMMhvpfIra1kAs0UDsnmSuYlfEV0lm9X0PBqOoSmTiMI9W+sMs1zAIwoEWDh9kkN5fB476KazcYKVXVQLXxQJ5bjc4Ae/7s74HIJIwCXdWlq47t62esOwuavCLKpKBM4jKXc+A8EB65KfgHGLIAlqMZ17xmNgtlPvBKXsqzd0nYhWnLw4ooH0RRNpMimPfpDpUyGW26hiQ5LbebdUX/YG5aJJrM0ZAtJNvzo8WY+YYAQ0vQzgjw+VI0dx/EwH9UDc0nni1PAd8O7yO8qWqBV8ustfsch0YoTyWIdaV6ctTpS2690YAH1hiMHo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 02:57:13PM +0200, Frederic Weisbecker wrote:
> Hi,
> 
> Is there any plan to proceed with this patchset?
> 


Hello Frederic,

Yes, I plan to send a v4 soon.
(Pushed the changes to my gilab a few hours before receiving your email 
today :)
I just need to perform some tests and rewrite the cover letter

Thanks for your interest!
Leo


