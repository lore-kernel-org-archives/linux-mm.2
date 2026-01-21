Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04D2AC44502
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 09:02:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 616006B0005; Wed, 21 Jan 2026 04:02:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C04D6B0088; Wed, 21 Jan 2026 04:02:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C2F76B0089; Wed, 21 Jan 2026 04:02:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3B2226B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 04:02:02 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BA20E1A0887
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 09:02:01 +0000 (UTC)
X-FDA: 84355378842.06.77B8BC2
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf14.hostedemail.com (Postfix) with ESMTP id DD4C0100003
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 09:01:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=T2Up0Th2;
	spf=pass (imf14.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768986120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ltl0vQZysF180pSnX7bz0rPfU/LxOA0NNr3UUNnapNk=;
	b=T+QqVbzv0lF3yTwdrD8lPG6ZWr8GhSaGR/TJKoaffdu9sTr2KwV/07w1LUBfNfKnhQLXb5
	FaTjN8VmDrJCpeq5J9LcHDvv1xRrnGyuvBB7KVH56BWj1NVuMvKLMJXt/zZGvWu5Xk5dCN
	66Y10cey6ztt30fvsnsp52BkOd2ttio=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=T2Up0Th2;
	spf=pass (imf14.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768986120; a=rsa-sha256;
	cv=none;
	b=FkHgdyRx33C3OiqeBpZw+FTWbND0xtfi9i+ncmpCQNa8WSlbs7l7KIs4HPZ3fIJ1km62a/
	qeqauJz8I4LMHites4kKEtky20fHPlUZdGkylLJDdU7WrsedX/PTFnSSdUR2QfojRDpscB
	eSe5IzQszBdPeOncqnZqg4wCTTdT8qs=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-81e8b1bdf0cso3635344b3a.3
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 01:01:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1768986119; x=1769590919; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ltl0vQZysF180pSnX7bz0rPfU/LxOA0NNr3UUNnapNk=;
        b=T2Up0Th2USay8MLziivkWkvLlUzMQcbiY+7xZfPgXw/OujZiVKPwkqGm/83QId5h50
         ezPohAOtZh3KnWSIrgbNWgW2AyKiJI2NpjS5BDwhAvYR7Z1MV6jxlJyXfmGi3s9NoYfz
         mrf41kGOO0yxWixU51ZpoKeTNOZdUMnDLZqP8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768986119; x=1769590919;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ltl0vQZysF180pSnX7bz0rPfU/LxOA0NNr3UUNnapNk=;
        b=XpOVwqilkoHofvGspVPQzy/FI9nbHXXl8iQsL+lf3lhsr2W5iDcDIfefzfZIV4BcWP
         zhwPdbgb2C/zDyHbRvB4da2y6mvtckEySFyIEGPIuxQc1ucqJqPrDb2UqgfvKguKk0eC
         yPdHzBwD2gl4DrKLk664U4v9odzBW7fmU2vFhKtmaIvd5orqTmXXUaYHiHNCRoocdOGx
         XTTozM6z3a0HTYcJtF4B4toLoWxCXIF5pVF3k+dISXasbSUoR8JbVxOielV3YY5MJ0EO
         q9/+LnLoMRQAxXAp3Fby3ztbVoaTDC5dy4k7fcSYzLmiG1eDyB3xNlC0YdYjjsNNFo/4
         uvhQ==
X-Forwarded-Encrypted: i=1; AJvYcCUVphuOWK+GfsJKedn8wS9K2v0/ycbrpByuJXbC+W+jx3iB6iLOEsAXKV11u8wyoEbrOOwCxgtmjw==@kvack.org
X-Gm-Message-State: AOJu0YxAYutBAzk2+57DmAxvSeL08GCzOSEQ/3v+x0SGyABAt3QveCmG
	MHuf9EZ928jK2ESZy5r4ZfA0r0giFRl4vGTvVcB9SQ3i7dEidnsWWEne6UksipIrwg==
X-Gm-Gg: AZuq6aKU8MiOaC9dTB6nFJ24GoD4Szr1WPTTrU1XPWU/1XDV5nYkV5iUw3bVg33LoHI
	aOPkg1O9Jl01ZLOYBQ+hUsFMjxJm0JemTa9GPtZ1laNgkpviO3o0ASMRsPkj+rAGGoj6GGE9w1k
	1CkBxUu60y+2ILsBGdPXEd2aRXQFfq0GBZuPb9cyxULCF/pAdhP+0OT6s4/y2kq8juKq64HJSqd
	Ii7CjgH1ywTZz5MzeNO9dr/50q+1/jfjqDS/FLXNdFboj9rddkgcl1ptLSJP0xr1KTfVn9wqYqf
	hpvQYscQ2WViT/mHrNZII8k3ELa1zdmHbC7Id7xBITnKeYdemhYx0inahBbMI7xUR9+lbcgmPnR
	6bsj9EOWH8NZbu9IMKb56CoSllYboVSI98c36VWclQjzytw8GK1MxGfG0QDyP446OnADecanSqi
	hFklm6PZ8+9/4dppdKD4yfbHE7mQVdx5qKc9ktUXGCI5qDz5Wtyg==
X-Received: by 2002:a05:6a21:3945:b0:38d:fa67:e853 with SMTP id adf61e73a8af0-38e45e6ce72mr4267935637.65.1768986118496;
        Wed, 21 Jan 2026 01:01:58 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:a85f:a6d:c028:515a])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c5edf32dbc2sm7823603a12.21.2026.01.21.01.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 01:01:57 -0800 (PST)
Date: Wed, 21 Jan 2026 18:01:53 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [next-20260120] KASAN: maybe wild-memory-access in
 select_task_rq_fair
Message-ID: <tjgtdmhtsbnxuy7obaumw74gpsolml3nucb4fkidxmhbrr3cb2@m4eqiizyjjlx>
References: <sjs2vhhxipw2zl7kya5owkrtdvrmj52dlqwul3r4rlyuodqnux@4rjdigvqofcr>
 <3e3af3b6-28fe-448f-90f1-4f2ed0c651f4@paulmck-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e3af3b6-28fe-448f-90f1-4f2ed0c651f4@paulmck-laptop>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DD4C0100003
X-Stat-Signature: eszyhexn6fa6e83bpdbdy5t84essec1h
X-Rspam-User: 
X-HE-Tag: 1768986119-927473
X-HE-Meta: U2FsdGVkX1/JuBlCqLM1tZXLd7PFgiTDgiDwvf1PkTQ0JxMwHRSrGZcYSCHSKdp+cmlY+wPysdiaduoqiEqwdlJ6oXwnIVwJog9kiTdZ0mpWLZmzO6Wx4Dg7PH0tnSYmiPMzuOfn7QDt3WKc6nap7ENDJTrdBF5WLh4Kps13On0kDDiI9wrKSuJ1+i58HQNbHjgTFWcUbBJ4PrBpVpgLZ6RT5xkErJ8LhAYJJ/iw0OoR0IR52YfQbWD9LXD9NWXn3zRbVSHAi/v4OE+Gi4aU84MYqJ33zAS4uK1WBHlYvPSjC2ZJx/9SeFYY8yiCVxeZIDb5AxSqIRuaO2Cf8uHG3DinIWaoXPybVdbX2ue88+YVRo67wThmC+xdnnZ0QRXsdJJ8EkQ83Lv414OL3pdvWvEcOJCGm80+QO7CFR45ytUHgqqgwTbVXZUxB7Q66nVfv7M41EazYb4KoIInQ6eRTPALIQosAYMMelwUJIVNjFT9XBMtvVU28sgloRiajdkliKRXVDBJ+b7DQDn+UeSJMZ/OvVFFZtN6mg2oQJP/nYaUiNWnP8e4VGQedz1UHSvLI5JDWKu1tGyEltjJh5emIjrAzvmYBmQSbz/ndtDL6yrZKPsC1lMZvfwxd38tFurIBXyJl03pxItUlzxUpF41Ee3A0JnpUbcxuL2EgVrb2Z3kRVyk4zsTHN+lAUNSniLeTcSGfZBofG9/v8PxJMqxXOLTeDpmH1o7bz7T3RI6qTXKBWfsUZrS8c2hEUPFIBnNA+V5rylhgUwsDktrxhPIhnk+XX4nmwZ9HKj16++zVxBxBBi3nQvaGeU+DW7E9kCQ69IQuc74Ys4Bjc5xG6qZVCcWGm1Rk/MeelyPQZcBrHg6rK60/koX8JXjiiMHm9flZ90UBNXwf1UolBJAwFaZSWGmXTAy9RGHDsU1RnybwZS9CkJYYibFNgFn5sk3OivY82+xGHgMDXar9U6+0oL
 LJ8+Zgzc
 h4HMGX1z4rG7s63HMIPhFSXpKvnKmKsR0YPS6gb5JrFn4yEkNL3hTejCdMP38biSGGVp5ih/qvS1X0qvplQBoKgV7xWHtCwejjRd1/0LmKpKp4M8/18QO3+n39nc7bwHAWwdoJWz5Y/YGrQxJTISibGVrHQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/01/20 21:11), Paul E. McKenney wrote:
> On Wed, Jan 21, 2026 at 01:03:02PM +0900, Sergey Senozhatsky wrote:
> > Hello,
> > 
> > I'm seeing the following KASAN report on next-20260120 (qemu x86_64).
> > There seems to be a lot of stuff going on in the call trace:
> 
> I'll say!
> 
> > [    1.714941][  T136] ==================================================================
> > [    1.715713][    C0] Oops: general protection fault, probably for non-canonical address 0xeb1125008e9810b0: 0000 [#1] SMP KASAN
> > [    1.715702][  T136] ------------[ cut here ]------------
> > [    1.716702][    C0] KASAN: maybe wild-memory-access in range [0x5889480474c08580-0x5889480474c08587]
> > [    1.716702][    C0] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.19.0-rc6-next-20260120-00004-g7dff00c348a6 #645 PREEMPT 
> > [    1.715702][  T136] WARNING: kernel/rcu/tree_plugin.h:443 at __rcu_read_unlock+0xb6/0xe0, CPU#2: devtmpf.X/136
> 
> This is most likely to happen when you do an rcu_read_unlock()
> without a matchine rcu_read_lock().  It could also happen if you
> nested rcu_read_lock() a billion deep.  Or if RCU had a strange
> bug.  Or if someone corrupted the current task_struct structure's
> =>rcu_read_lock_nesting field.
> 
> Is it feasible to bisect this?

I started bisect, but due to circumstances won't be done today
(most likely will continue tomorrow).

