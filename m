Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 109E6606A32D
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 17:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=k6eq5d+7
Received: by kanga.kvack.org (Postfix)
	id 049166B05C8; Mon, 23 Nov 2026 12:38:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 020296B05C9; Mon, 23 Nov 2026 12:38:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E51A66B05CA; Mon, 23 Nov 2026 12:38:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BD54F6B05C8
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:38:03 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 28C5E160971
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:38:03 +0000 (UTC)
X-FDA: 85467092046.25.BB83904
Received: from mail-dy1-f194.google.com (mail-dy1-f194.google.com [74.125.82.194])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4ADD71C0009
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:38:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=k6eq5d+7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.82.194 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795455481;
	b=XKK77bDdpcXSWyxF//vDXFT5cdms9n69Mxax2MjB0KjDfdV78vazsXAF/Ma4sj1SqFaTEG
	TaxCXTNSB2VBz7mB/56W0NCrElTBWIxhUEJhUVFjw9ZMMdNKYotn9VdpIxdIWiGYHoC5X9
	YpE5hUaTgeb6NHFvmhrOmDQa9ekPRZc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795455481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GdeF4xDXe9TQaYIgdFh4G15+B2cWd0mkAefbmf3E/zI=;
	b=FHMQmMA38EqwJ/tCXbE/XxZbG+9ffaa94mgRw3DzVRLDr1P8GHjsxuqAcPbU8KK40AxRjX
	Ghj7ESnKIh1N5M6JifrYteLS7lM3g7MRA0OYjJ7WeLlPFK2m5Cbs13IlPBMqu00dawUx6b
	ZTXZsVozpjT2eI8XeBXuBwmuuc1qDhI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=k6eq5d+7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.82.194 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
Received: by mail-dy1-f194.google.com with SMTP id 5a478bee46e88-3869f03af6aso2696331eec.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:38:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795455480; x=1796060280; darn=kvack.org;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=GdeF4xDXe9TQaYIgdFh4G15+B2cWd0mkAefbmf3E/zI=;
        b=k6eq5d+7haZvFVHBkf51FtXKSDgTluY00GPVaUwkqF3RYH5WGKxsBpV6F1zTHRkwXD
         HZyfpj/PVVsdy9vXNRUP1mkYbk6I0lyVxH7yLk8vJJgnePiAVKDbp8cbvlvt+7gOIpDK
         aQu3r1NIApQGdZqrp5eRI2CioH+Fxt9+AClj86UuOSDKaIdUjNW1HCTn0Vsi4Jqfim0E
         wmbuMRBVZ/ylcNfDIusEX41bqOupMHj29sXglkh6rGgWvycQ4pCOh8SR+XwgMA0nuhTz
         UMtCjAEYtXGaWdrop9YmfQNWYKmLiaFlHDRpn1SEMarEq8iodEztOxfZjW2cZyJTi5M8
         wBNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795455480; x=1796060280;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GdeF4xDXe9TQaYIgdFh4G15+B2cWd0mkAefbmf3E/zI=;
        b=mkINswTAZxJfhhFY9HSLRJF8HMAKmGzfVtlbNc7uRgZyyOTxq/fmEhb5V4cMy1KwMa
         VgT5q79vCI7dW2qZ9I4CXWA5VbDmQmgxAOKF5DLWHI7q2dY15BikE2Izvmc86H3q68uG
         0/9JHh32NdfJ7iQd3KhuHBBbJxdPqlH3tjm7rnDshEqpyYw1swqVTMFnMRW75Kn/xdCZ
         4aVt0Rx+iwTcyTc+yEOHqDjOuQdR63ndPFNSa7ETdL5URS2OfpdG60YL8fUfwJz1V76A
         43SZtO1+/Dz5i/ctogYFur5/ASWEvLZ8kq7ojMg2d5KQeX0bmy/vV8TQPJEyNl7UbiNf
         VTUw==
X-Forwarded-Encrypted: i=1; AL+hErHlsLGdz6vWEkhvQApXzX/mnXk6ZtpjQyMVLbaHVC+eILf3FmUpQ/YtlAcO/e63nqgoBBCgF7YoTQ==@kvack.org
X-Gm-Message-State: APuU4Z+HbuiRsc0Ght3BtMpEa+gJrtMXVZLUgd2AAmcNJKLCrjsqlYJA
	dmFyMn84BxGjmKISaUQZx6oAEfAtKVtz2Lr0usvmZqdXLcAwl4OJGlD00yMRLknkEs+WBA==
X-Gm-Gg: AZFdTZfGm5oPyj2/o19NgvkkG8PBvRJ6sUbs07V5+DvHlJnI0lRLeTAbc7530hyvyWN
	rrzC8IvIpccaePp2RSvFMZu4H7a3hHXRWuQZsxEsjkMFobqTumsizGhpfi+cDks7kdMk/7ifMdI
	0cDkySkXf0irQbdQN8ArEnVL0Dy0P7OkUdgNr8UWs5JIduY+Fwvsm+EIUhBWS9FBkXS1luXidhR
	009IVGQRI5Xxtjg90hCPCRWki++tmvup0IPEBXh0rhOV13qn7IRp2jwQqPer68BUMki5esmUXhQ
	fuukhYSMPdo8C2/vAxRpk4utONmH2tuENRDqELa+l30V8E7JAhpEE3MBRcayArWOzU0U6fG8WG2
	GRfsHF3UmSi7J9y7pCq072EOeAhnwODhbl+boUzlnTRIqKH2gVliY83lTx53WK1AhVgmXYzatBM
	1uO0k/PJnND/0ittBijvFe539fDIp5JCS2dqJIFnctwBk8ZM11/R7Gt7BVUhdCpeN8DpA8hxjjc
	9cjQgRVBFwwkd/c/jDMuX0CBiCtQxppBfDGxfXtghGaaHkpEitA12K7iybmOLH2SYFlrssMzQmi
	t+MVRqgves0MhH97TF63xLb5xFoZ1+/hV6TK8TvKs8J7HTiiVGxsX3QfMzUXToyb5+frISHosw1
	yxsK48AINOq5J/UiF//gAwNKaA3Sto6LtV71Jvwup+xh0LbKqj17Hknq3dUm+vw==
X-Received: by 2002:a05:693c:25cc:b0:369:f17d:efb with SMTP id 5a478bee46e88-384b3e77699mr19708498eec.10.1795455479865;
        Mon, 23 Nov 2026 09:37:59 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38567abb870sm31532302eec.25.2026.11.23.09.37.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 09:37:59 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 19/27] Docs/ABI/damon: update for REPORT_MADE probe
 filter
From: Aveline Noir <jm5905938@gmail.com>
Date: Tue, 24 Nov 2026 03:49:24 +1100
Message-Id: <179545256493.4.4781615741827867830.b4-reply@b4>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
 Lian Wang <lianux.mm@gmail.com>, linux-mm@kvack.org
In-Reply-To: <20261121210013.130397-20-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
 <20261121210013.130397-20-sj@kernel.org>
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 4ADD71C0009
X-Stat-Signature: u5pcxeqnhhun5ggyrfsb338g6z94fpfi
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795455481-946919
X-HE-Meta: U2FsdGVkX1+7mNOgW/lSuz46w/P7xjNZsZx4j1S7eG6t45VvLh3l2qrsEMQotpmkaCjvnIo01YOYJogGmlh43LLJhE9tsOFVfSeXGSGAiw99mJ1SQEtl++aK1Ie9KM6T2ntEHY0nVhwjtZbIenjVGIOek1ksvBngmngbox7Lk9yCKs1ZoSQdtK6cRkPKv5PM9y69F43V4cJ/rfGTbtX8ro9eDBTjGJUZJlDiTsRTYFU8QIDGKqZ6vZ6B8ObNq6xqvbYaaFnePW1CxdaUw/WiCL4WgOVntnw58AdE7ScwNoQ9JnpczoftP3i4Vu4raKdJAecjmRFqp7FOycD+gzH48sHXfD3/atbMAiJKEUm/zYJqDxGTAfwALUgv8Q6sqVJ/WOQnFJEE3EsZvoOuSxyirNLaSqfXy9BI1mi8x/pYaiD54KV00brHoMGqlf0b/P9QAO1VAcjqnyH9vltt7UEWyzLwfttY0Z2LKVJEl+3ML5GZyCwtynfhcujsjG/K88I29+t7YIicPFf5EF8NxDLqxUzqHbwhgc/sFag/rf47q1nhN7rnuZa9JdY5MAlND5+BOVyvFpIF+U7GeP9IlWun0CAmflNoCfiGjzhe+TjY6SSXjpwExuf2p96IMMvc9WJHXTyQZHUimaIzK9EeytqfmZCwt+bOunw4/DzY9vYjr77m6PWEJIa1T1r1UYSNuXbO2NS4TOASdcDcMuLfFx1qEqJnocskezuQ557TQMu0JAR6YG043s9OjUoYCBtqqlVKQLaNo9i8Deah6gL+edmaK5RRQyjP1bhhv/jaiaghpL3cfe9biGf7iBlXA5g5xA+TKo1VKJifum6Wq+h9bPaMLYx0iL2tiDFl9nSq0tHGWCA8F4IbFJ0Q4KOe0N8wIC7OBGPNhB6iqkflEDMspMoelSIQbBdaGRdlLumNVe7cj7noFZizDhs/iEUcSm7ywL9FUqWySO0ljvD4Xs5BL1T
 9bBmZ3JD
 FgQEwEFfgu0SG9uradb3/yq90HgdOVXTHXhAPmR5PeTe0zHBu9wPqEeMe3qeyS48U5+s5X/u6f3MjLVH2LSsnSE+8h5oDMQt8nRPfh4gv0BVoz1O4lbD15QMjz5ZnFZ4+ejUMrPS0iH0BLfGgNBKZyZcY6RpASeTHquOWzXK/OO2l570oVwI9UH59lCoEVO+XSLWdoyjBYiXmeDj41PLiGe+8TdSxttDbpu6HdKPZyDutIbgc8Xn56GY+hkJTpLiLgBbel4lCJvpbLmLsWWd2c/e2BSeuzK0hkSOKICmmPbQ/BwEVazEbm3rqypwRj6zvbIPyzyAy95UhhMjdXjYliDU/f+uHpn4TkX5kSDEX3HCU0kqZKs8+hJCWjbqRgA9crXQqw0cEBargVGw9wLisuRIvlq200aFaxPI784mb0Gst8SQ1rcASOUi2ZYWSh+GFL/htSbNTJYZwJFkm1QmRFU6zZcYXUucxgyn23yHN9jTeSN2ZvNZLO4a3VXfWdFn7dvItCKLBNj8WYm3L9/JQFQlLlppcxmkCiDuFj27P+r5n/7nhUTiGd3XRObyhHgYdHS+PhDsJCNofK5BkETgp2G9giy8rBJ7EcvMH61gT0dfLeDH3zZvqJNeqwSjD/6uOuykXMeZC+W2W2TN6lWCTs+P8XWa4P36pLpJfQoCwXQNmI+WChQMppUpgUfHy5QlGWRoyICzaP/lPWXaRx3lpqFmBgcqL+D5oB9DnD3J+76P9SQaVDU7JXvmmIsrNQMPTQcFOQe4HowjqI27vJMNpgCosRhdHRMEW11gjpEEFsQ+Z1gEmTQdMLZU16Dq1RPMqr0Ge5zgIGloSWLg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Sat, 21 Nov 2026 13:00:03 -0800 SJ Park wrote:

> Update DAMON ABI document for the newly added REPORT_MADE type probe
> filter support.

LGTM, thanks.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>

Thanks,
Aveline Noir

