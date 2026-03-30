Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD32110D14A2
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 11:46:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F6196B00A0; Mon, 30 Mar 2026 07:46:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CD796B00A1; Mon, 30 Mar 2026 07:46:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BD3F6B00A2; Mon, 30 Mar 2026 07:46:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EDDE76B00A0
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:46:22 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 95D2E16052B
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:46:22 +0000 (UTC)
X-FDA: 84602551404.04.89812FE
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	by imf15.hostedemail.com (Postfix) with ESMTP id B80C9A0013
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:46:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OpycOojJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=realwujing@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774871180; a=rsa-sha256;
	cv=none;
	b=gzvKNS6Tsrnamlr9vMNYDhlPzGL56GHomCNF1u6uLm3voDahQZeoj2YfFXcfa3CoR3NLsm
	wjODM+6Bk/Gat/3iL2rZAWFGuHNcOuAwfJVynrujon8djCIvM+gmwPJ3iUO8hdLf6IvT14
	byIjyLDBp20Bzr718Qtv4RQoJsnkWKQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OpycOojJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=realwujing@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774871180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=88r4nrovufv2sJYIOMDGEaf/zyrN4LEqGmAEdjsIQK0=;
	b=BmamUaD9ULQmIoSDa/ikzK9KtA3G3gEVRK4h3zQ9LfW3rz7Oi2J+/4XWbmxnriNI/f4l+t
	ykpbJ1P/lcoYBDI87SJosQYjzF0r2i1QAQ5d7af9sAITdB6uxs4GyzOHVSUM1fbfoMsiII
	DvhWPBFPOXd39c4dampHfucFSCONJLo=
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-1271195d2a7so377714c88.0
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 04:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774871180; x=1775475980; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=88r4nrovufv2sJYIOMDGEaf/zyrN4LEqGmAEdjsIQK0=;
        b=OpycOojJSoWp0MuUpC7fs0cf3k4BgaMy44On23HvPHl64YEnw9kOc1iUJ99QlbDTbY
         NTj+gf8TiDwchlpM1AnH5sP1TzBsmhfct/QpwDks8/xewfqn5JS+//SYE/Xn0Y2wQsG3
         w5gF1xrYZhoOZn5P6eV1L1GVt89MBX4OJXEvY2Zv2IpM7THwTzwWMSHt549I+LqS5CEF
         r2esD2u1FAvg1lkuDkoHxNqICKS9twrQqEV/Y8fJuIU6rNKJeY84nEp/hiPV/16piUYu
         n0mfspfgiiJ3lwmSBklvNaw4ZBToVfIbLRmoVKDsDym7+RShQxz29ZPHZKAduK0actFZ
         aMYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774871180; x=1775475980;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=88r4nrovufv2sJYIOMDGEaf/zyrN4LEqGmAEdjsIQK0=;
        b=tEbKOIwbcRi6gj3Re6CZvcldGITpCFOWg2ugCnmdkXiQU/Q7Db/Gj23Z4319ad1qNv
         8JQKQy8oRvLOvU6h3mlgc3Vr6V53pwNcpo7cY40ERsAbuJsJWjmqeA5JrBj4YZxh28mQ
         HNrwEdU9KoJUkc+2AaB326mkxi8aUgkh0U4JC7LozrFBgc71F/A37jPuC4W2OqyhddnH
         Dn4sJ+YUKOxKuuqeENSMRbx4y5q2V8UwmY0tKODmb6AV6N6EhtVSPLQJNAgWyvw6aiAZ
         5DViaNOVKvqq/veL6riOwY2+BsLCd7UmTbcP74MB2ZVvvZNmdmUhqqhxXS2nI3JLToUk
         gBSw==
X-Forwarded-Encrypted: i=1; AJvYcCXWRgDE1/OFOivICWXWnABGWwI5OkYZPRgJ/Bi+TXi1LxmSTPPb8vM/pXo2jl365vtSSq8iGfjLDA==@kvack.org
X-Gm-Message-State: AOJu0YzDlRGW62DazOPLwjaKfR28xw32Ws9jwG9Y6RcXtre9gzJQnJCV
	5OnfvzJceD+JGQfyVzQX+oOduJlXXvvmCAk1xnSGlSAEE14RTOiIdn/B
X-Gm-Gg: ATEYQzxOX652rxz5BdPoL8KCA0tfElOPFsfVJAdTuFvdICvSOdzNvGOeypuui0HiIbI
	Gnf0O1GyK/mVc9pFi3o9dEB3sfqhNYETnNrrU9Q3lyhASa8/0N/a52qgW5jBbXFtLenJascj6r/
	w5/+MPpixYHi6d6y0eStP3GjgVXSA5Z5a8HSEfFfA30gjjRsce5ePHMokN8oUqAaCUk5DtzEMxt
	MA8iTuHJfqx6KNR3scJLHpa0db2SZb8n/i3LcXiWDhyoYA6mx4WEHhu7ZeQ3OPjQO/NuuPikgL+
	WFoXVJaq1ONtS8o3FRLIOlMFSzXUeQ429s00H6ZEekYwAWVVAVtbvrEIDEEiWKYdV1J1hZf3z32
	pnqz/O0j6Pw0CQxmja7tJQieNr45O0m96O7SP2O+dRmfyDfrtbO8KlPUJxRWpxrvSLON4McwG40
	XnyozCiJkaczAVDIzjtqo22SgWtjh0JwMycRg=
X-Received: by 2002:a05:7301:3d06:b0:2c6:cdb3:bd5e with SMTP id 5a478bee46e88-2c6cdc30b84mr964511eec.28.1774871179502;
        Mon, 30 Mar 2026 04:46:19 -0700 (PDT)
Received: from localhost.localdomain ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2c3c6e9c088sm6703832eec.21.2026.03.30.04.46.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 04:46:19 -0700 (PDT)
From: Qiliang Yuan <realwujing@gmail.com>
To: peterz@infradead.org
Cc: longman@redhat.com,
	cgroups@vger.kernel.org,
	akpm@linux-foundation.org,
	anna-maria@linutronix.de,
	boqun.feng@gmail.com,
	bsegall@google.com,
	dietmar.eggemann@arm.com,
	frederic@kernel.org,
	hannes@cmpxchg.org,
	jackmanb@google.com,
	jiangshanlai@gmail.com,
	joelagnelf@nvidia.com,
	josh@joshtriplett.org,
	juri.lelli@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	mathieu.desnoyers@efficios.com,
	mgorman@suse.de,
	mhocko@suse.com,
	mingo@kernel.org,
	mingo@redhat.com,
	neeraj.upadhyay@kernel.org,
	paulmck@kernel.org,
	qiang.zhang@linux.dev,
	rcu@vger.kernel.org,
	realwujing@gmail.com,
	rostedt@goodmis.org,
	shuah@kernel.org,
	surenb@google.com,
	tglx@kernel.org,
	tj@kernel.org,
	urezki@gmail.com,
	vbabka@suse.cz,
	vincent.guittot@linaro.org,
	vschneid@redhat.com,
	ziy@nvidia.com
Subject: Re: [PATCH 07/15] watchdog: Allow runtime toggle of lockup detector affinity
Date: Mon, 30 Mar 2026 19:45:46 +0800
Message-ID: <20260330114546.103726-1-realwujing@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260325140324.GD3738786@noisy.programming.kicks-ass.net>
References: <20260325140324.GD3738786@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B80C9A0013
X-Stat-Signature: 3zq1btuiq77zjd1fmnn3yn9ns657sn5h
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774871180-577545
X-HE-Meta: U2FsdGVkX1+TsAymy2YSwPMNo8a2zkY0ClwG3YKcXWsKvhGMp9LUatiigF6Km6ar/lChqbn7KnmZoZUT74tURfZXtHoR8vXm308RzTcXf1VC1Lb/cVDcQUI5csmbRj/v0xD/ct82LfG4gSWbx3izy8Fh6Wf+Ax/KRspOrZs3g7/dzm0BxUwVJX8+7q9Mj/pLwPFrQFJ03oTPKWZEsfM9MPTmysi2ElFUYzuB1jqMHaqEtyfGRYco5hfTi0fbCg7toiAB1wE2iMZ17FwvbMmEk8FWmFt6V/B3Gyd709FqphNaIjkmBHMBCJ2fX/1YqYH8LtzF2RIuF9Fq7xsDElPivd8lf5hTEKHSoemtXZ3unt6cJ9TP40T50wTdNg/DTlpZBewoZLjaX0lgGt+StxXa91GbxOdGl8FLHSzjTpPc9AnBWi69UG9hHmLx7+rmnRFEc/i8M+B1I1eUfkNsYZwaLsz8pscoyBirNmgq+DpRFIJRuNi7/xOD6KgLydpt4ZfgI8Xf6Vy0peKxINF9a01TaxdPAjIu9hrEbZNiHZgyykF5PhsEpFaNV1D8de/eByvfXNz5juwPxzyn21+HtG8q0LvHKirCkSKuu9iCVpQs5kZsQnvfOblovt3a8lTyT6JHlfSKF3DxL32TvCzpbGNvMjhBRZC9n6bl5mxQMQRi+TUC2A/3SjsSjhtUT3bipoLMpmFvp8qmI59xd5ftIX3nPKhMhAh8U5GjrOwvUVWk5Jqs2Lo4SVMo8Bkztrm2e00+mRGiWEBLppJsIZ1qkDvIZrTZ3jp53/+z74HNJkbr8sLDxMFZwAxSVwwap5tPIE12m/NhobRIjI6BsOsplsIB4J2Fy3iAWqLkPFzlzYnXxCgolsqlLv6PRjkMJxk127+PVoDoSDZ5pNcjOYKaYE+0+2T+cGffMLMVbRLLpLsLF8cNdvRa3mE51i0Vb0BW53Z4kJhtahDmHJjF+xoqnAH
 eODuIgBZ
 /q1uCyqp3F++PhNU+3fDbQ/wwGGBpJD3/QSqK36bU534bXVqCoKn8O6u49CIKbD90u17JoJQNjIi7hQRVZBmoRf+D2JNIMfEoSyYi+Eil3lRwXpDt3HxN0f1SZjsk4mZr1YWGJsbf5HebHHQhO2rjJlMCYdo5J4Ioz9bKYdf5XI8yQLGQRURnTy7JDJtCWXqdE4FQBzf7R41IFRRjLRvhfRZMb2681rSsPi4y+201oz5XvI9zA3pBtCFOgbVlYa6Byedw5YJZjn3B1p8ibUzhzvm2v5TkltelCu+6Gxu8WWcUE9VghFDa5m5YvSID4+S70SoMFVb4NDWK/Ms4luX44xnMJIn2++3hYVVZIZh45mPUcwhvZvE74Q8Uhzz/A1Z3uDMnK6iBPp/zbHk+8iqJBvKFwljoFxh9gDMnVu5HQf5y21Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 03:03:24PM +0100, Peter Zijlstra wrote:
> Why would we want to toggle the watchdog? It's linked to the 
> TIMER housekeeping type anyway, right?

Yes, it is. The original patch had an independent toggle that felt 
redundant to you, and I agree. The watchdog affinity follows the 
timer housekeeping state.

I'll simplify this by removing the custom toggle and making it a 
guaranteed side-effect of the global housekeeping state update. 
This keeps the configuration simple while still achieving the goal 
of keeping the isolated cores completely clean during dynamic changes.

