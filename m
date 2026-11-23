Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8728E606A331
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 11:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=WgRzvDAh
Received: by kanga.kvack.org (Postfix)
	id 89BDD6B05C2; Mon, 23 Nov 2026 06:49:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84C5A6B05C3; Mon, 23 Nov 2026 06:49:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 763106B05C4; Mon, 23 Nov 2026 06:49:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 545606B05C2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:49:41 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D2DC4140874
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:49:40 +0000 (UTC)
X-FDA: 85466214120.08.4A52F65
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf30.hostedemail.com (Postfix) with ESMTP id 056C980008
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:49:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=WgRzvDAh;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795434579;
	b=mOc6V/G2QQpwVU2wPGPSi0yCVDBXgNLDbBzGxGsfzsRyoXD1GV3TI75ynnoVcpViR471B2
	AkASrL/Z+vEu0Ivo7KZ/SgPyR879GO4l175T/FujhSXma1p03fZluk9YdNcXcdoni00wVb
	x4y5CldA8hC6j0M4apBxAZTDx5VnV14=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795434579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nZFSp0goL8XjmcYoGXv0HxNvOIB0a28cVRyu5V9lYRM=;
	b=dlnkCK3r9BkTjR42WPvRUe7RI78FS6JnFlYB8kJV6yyZe0saR8SCc457JgNMjgup2zo1oS
	1Kz7uYQgDuQRAcvtfbtvOx1ryF6vjCByqo79IF6dByhWQEB7tU/nK15+ZvbSHKZHc26AE0
	MyrQTexIcLcGRBpsqk6ndyeoRzXT+40=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=WgRzvDAh;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a3517554f7so29693915e9.2
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:49:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795434578; x=1796039378; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nZFSp0goL8XjmcYoGXv0HxNvOIB0a28cVRyu5V9lYRM=;
        b=WgRzvDAhNcT81ejt7/Y2/78dV+CBqEaXKxvA7xsPur1QFpliiOfB6JTnx3+kfK8ZxL
         5J7UQMFEiMJNwCmwCTLsWmlw/Ipw8ua6d5qe6jtEpOWmgWudDFIlFE63NB03xY5sq6Th
         qfuym8oGbpiSwLMFy8w0647qJjMzw6DvCa27Aiz1IfAzmO0aSznj3Xzqxgea0K3MPu+t
         bQx+yskCJHkRI1gwqJAifP/8Bs+YJ24cun9L0P/Yxwtj16m74HPso+NrpNYg52IK5uo9
         z4WOLIDGO1fK+sXbhUHasRBamO+MtIOoDGxnejSy71lyIgNVfyDKpQElPUaoUoHYTMy2
         P6yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795434578; x=1796039378;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nZFSp0goL8XjmcYoGXv0HxNvOIB0a28cVRyu5V9lYRM=;
        b=tSNB4cDHU7e0ln9+CElMSnunq6bvskQhWsf+lBYPvM4AQJWh6vt9yYLIIeIBh2h4jq
         k45BZtA6WPE7RtMctg8Ji8d08o/jGPSTzqntDumZ4ugWLM8eth00QTapTapgXCUEp5FD
         3/n3WGE1EaRPRslH0RDDBruOVgsvPsLO2e6+96rWRulHzsz/qSwStblstPU+EtECLlAX
         BuR69taSaV7hx9p8Pa0qcljbXPCfLRMd2Z4G8tmExMfwOl006hC6ZJQdIS28kRxlMNB0
         pUMZNMkFWuWJWiS1fmzMjBwwIemhCzNB8XXlAw11d2svv8q5KU9HZ/i39QCO3e6lxgXO
         Jb9w==
X-Forwarded-Encrypted: i=1; AL+hErGdtjygrNTl1VFTecFku0qg98/GOwCGJ6pgcvhr33I0xN2Nx5XQh6NuTYd3t6nIBffpNx4lAw8zCw==@kvack.org
X-Gm-Message-State: APuU4Z/ZHGC3zmYsjHZLVrUfZZNrGQ4LvUC0HiG7lIx/9PRf/vPK8TZk
	Mg7yQIjINVcnG9nwKpZw50B9rmbmp6GAcVpRvpfwXmrHxEahGcdUtTgIyakF6iCupWs=
X-Gm-Gg: AZFdTZfQy385IyjN0OgMo+wjqwUD8d6OQzTJ8MEffzC1OCyYu/9rLpxHGaPtZkQAOmq
	ZFyGqCIJZ0f6aHTBdSDucoi21Nk2/MugwDieyqZSwtyb6LZqJClGjImg4r5B6IBhq9WwqLw/bHO
	dtKLaE4SRlmxWjYfJY8XO4wmOcfZkVronSUnTvgVO/vv/q1+JAgbO+kbyuj5Khn5YQQ/uEaTaGq
	wQ03cwGXanedbh9CyXXXItT7MuIKM8RtXmHQjQe/EytnkCbf0rOxZThcG5fAt1joFo/bxuoaeRx
	cb1auQhWRfEJVpyLYP+USE7saf/JsGwoLayeRqsyDlYxGFJXaX9tflEXjfxf81OheyMWqIYIjdW
	xaRDM5kC0vWO2vxw9d7Y6xWCdUqg7mhyu4bCpL31BHSJP1djz4ic/Kx0KwyBng7FY2lUEXXtq+M
	M1SGbkHimfLr3QsWjqReZQXwU+19N2NSla7AdstKLHMCREvR5DRukZh9zDhYNLzyguggIEUZ6Ep
	nh0XA/HD43aYrAwVeZ/AL2rLgSkeyopvVhjqLCHuipQOoTzvBSiZRvounm4ifl+9ggrrbpo0Z7z
	AWoJUEDAWPRlKJTUdXvhD/nzN1smmG+dHpxFY6wBbz+01qkt+6rZ4l88+38576kM
X-Received: by 2002:a05:600c:3b1a:b0:4bb:875b:3d91 with SMTP id 5b1f17b1804b1-4bb88820bfamr238565805e9.30.1795434577759;
        Mon, 23 Nov 2026 03:49:37 -0800 (PST)
Received: from localhost (109-81-82-199.rct.o2.cz. [109.81.82.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884ab091sm495277235e9.11.2026.11.23.03.49.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 03:49:37 -0800 (PST)
Date: Mon, 23 Nov 2026 12:49:36 +0100
From: Michal Hocko <mhocko@suse.com>
To: Zhan Xusheng <zhanxusheng1024@gmail.com>
Cc: tj@kernel.org, akpm@linux-foundation.org, hannes@cmpxchg.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, penguin-kernel@i-love.sakura.ne.jp,
	mkoutny@suse.com, chris@chrisdown.name, cui.tao@linux.dev,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, zhanxusheng@xiaomi.com
Subject: Re: [PATCH v3] mm: memcontrol: don't miss processes whose leader has
 exited in OOM scans
Message-ID: <awQoUGIBitX_uvpP@tiehlicka>
References: <305c5803b904a57c188b505d6ed9e1e4@kernel.org>
 <20261123113951.1771223-1-zhanxusheng1024@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261123113951.1771223-1-zhanxusheng1024@gmail.com>
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 056C980008
X-Stat-Signature: 6za46b9zdebxnddfxmnsczyf1utxef6r
X-HE-Tag: 1795434578-303783
X-HE-Meta: U2FsdGVkX1+eD81t59G+kKdbvWlSsvpKUn4SVB2CKUS1y+pxb7mQ0L0KT/mWnXcGaanuGN535ZOv50zqfmOqOUD3TyYO46/n4+E+9kI0Dw6WVEvBeCtAlMCx8t+l5kRm9ya7DOQFn1kVE6dYBSqJb5bcAjeuL43s8ertrb1dVoUIXi+3cRsqNYyW2afVS15xyaib4UYCGrZX+EPTEOnmy71SJyh9rGfca0RrjEizU4CuDxt53aoR4++s9+qx/kbI69i0mvcHEAEJp19DqYxfK3WwXkJy3lrgDmn7ftkVBLFpIlwd1CwK/x+zjmcca3WPwU3PYmOU24GtNNgb6GFnki5pLRqzx8lF1KQQoTJ54RHYH6b4fS+9v28Cbm5KUtRO2BeGGmbcblmmTVqla/UO8veOznX4hxH/hASuxpj1KJxthR67P3+TneA2BtGqg1nie7jyqqyhbH2QcEWiQwqRlkPVCwFnuzpz+jfHkoo6BD7M/X3kDYZvTJbQcwBzWjaOO9+34ZBFWKXi22iyY5nvRVxkSJm09Yj4cR7FmPeUVQkj1bylJPEhrCtlxL79abdquU8CWSC5PrwxkNWRxYVVTDXr377f3mIkQ+WPxuSfZsXUaqKCGS/oqwnp988uIyQc8+qO8hDaqu/pyxaU+PJfYxMO0z9hEINIgnZYRH9GPx170mhERZK73L9KIwTFW408VdmiR4AEXtfgXyioWq51z5hxMwbupJ9bzr4SSN+DSdHCLVDzDcKDhCpFJKdLqidmGVwPrVP88Y7NLzGu2KyeXNRpoZxhwsB1uTy70fsTfvEUbdmM96CPDKck/eeaAHrUBq9i4gdxhprz6B4tWibgCM2kxEEdI+mvyifNerZpDnvFvefnK64FQBo6Tc7gqvNKn77YzfUSpb6hXUgp/v+XkZr1msRkqMz37v21nEzbprZZcm29BkcHzquyyN49vudhLTGTNPIbSAejXWzjatq
 IMur5e/4
 /aRZVtrB0LOq92DQX6pXNJgoOCanId9UG7GawZVeuobD4ECpOkErdYzd+NLPFB806VIzVNhDkwOEWLGQonKo1e8nDo+sYKxS/drXV2qMsAtn+KtJe1O2obsEgczZesG+kAJ3t8u9iOpy1Y+YL5pKF9umuLtDeg0xLSvjJoeMaegTle4huN4N2bV72xtxBmgcZnV7EV2pfCIBYTNm/Wb71wei4zHvXzWk+j3C+0bBIlgBZxTC3ObVklLW/Rc9wCKegRnURJAj+3hVhRKl88RxmnbaKdt/cJJzToJ3RgZqTRZq3MUeSoYn5yzePu7G0NJtB4PimegJb+HcjxYdx4gV1ptVcfSFmWRyl3XfcC/LKXDp79SsFnELUpeGxJEHlzvb3RYyO9BmIXHZYXHb2LiHPxKiIXsit0WfauSBvjvIr4UfaJor423VWfIXh4k0eIlyO2KBiVeK6iAumbJB7Q4Es5yyc8xCZpE3T1jNee0L1I5SQco/TpwYGEbSMzSBZ/ZKWccncEAO1zyKkJn0AdOlvKCyA0kJJnGxC/MqKY88/9x/oI82juspkLqfSwbsNMz20CDdOELYOk957azQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon 23-11-26 19:39:51, Zhan Xusheng wrote:
> Hi Tejun,
> 
> On Mon, Nov 23, 2026 at 01:13:25AM -1000, Tejun Heo wrote:
> > Maybe the leader can pretend to be in the new cgroup instead.
> 
> Thanks, I'll implement that and send it to cgroups.  The memcg scan can
> then stay on CSS_TASK_ITER_PROCS, so this patch is not needed.

Thanks!
-- 
Michal Hocko
SUSE Labs

