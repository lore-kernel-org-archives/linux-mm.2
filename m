Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43812C5516F
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 15:01:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4344B6B008C; Fri, 31 Jul 2026 11:01:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E5666B0092; Fri, 31 Jul 2026 11:01:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D5906B0093; Fri, 31 Jul 2026 11:01:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EE2926B008C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 11:01:13 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6CA231A04AC
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 15:01:13 +0000 (UTC)
X-FDA: 85049384826.21.A975423
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	by imf12.hostedemail.com (Postfix) with ESMTP id 378014000E
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 15:01:11 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=WVV9HctI;
	spf=pass (imf12.hostedemail.com: domain of axboe@kernel.dk designates 209.85.160.47 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785510071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0QWMMe323FpJCSMO/+srY4nRAHRMTDbNnpPaXX/8/JA=;
	b=K2Uypg7SC1glm9WiuG0dgRIoFbjXbnuJ4EdTcRLbfUZu9d+uCXb5gGujEMw+DHL/0Mm5qo
	6cWBymHlXYa7gPqROFMfjJKLMjuQ1CsxRDgbsgoc6DpYt5c3X7QwWKaJwi98YAOZVvGB2o
	HiY0KK55Or4+nr8zEkL6528UtsbituI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785510071;
	b=n2vrJ2ZfQLr1sJbBsH2HX9BeIo6tf7R5uWIfTFwjy4m1xzZnNBsa9qoWrN7UHKbWkR2VnF
	fNIk2k3RMFUZ5uq2kWP/1/tAMdctTo0ONCxmiuPFhT3hjEo/qxkuR/rhbT6rr+KknwmWt7
	IooUEHdSTbmhZvL4o/fjumJLNpnWW84=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=WVV9HctI;
	spf=pass (imf12.hostedemail.com: domain of axboe@kernel.dk designates 209.85.160.47 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-45691990234so761810fac.3
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 08:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1785510070; x=1786114870; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0QWMMe323FpJCSMO/+srY4nRAHRMTDbNnpPaXX/8/JA=;
        b=WVV9HctIVTKrA9LjdPGCT6SQPxPYh5ouu1dTcR0MGtu3dMEIJWRYJO7WlyOUFotalS
         kWW7ePBW7fDPYLdJJ1K94NdmNCQzE1xoF/GSAO4UHxXwcuNGOnWsRkMrk9pdMS011Oqk
         BEUrdoQU7InvmljKVqDJdQEzTeG2U/wtxouVcs2q85AL3yc6hcKLu+IC+CWeIoZpa0kl
         t75D2vpE8SR1gX/K2Nxv9HTUfDq2Rz83QwUp4mKcegHiGOqC8kQmjV/x8+zQ+uGy2oY3
         Fi12AbHmB6lbO+kQKnTkxGqF9ObDIjFEOndPNwHaXAGyI0m4uos505nVTac+ISnrpmOX
         BrWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785510070; x=1786114870;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0QWMMe323FpJCSMO/+srY4nRAHRMTDbNnpPaXX/8/JA=;
        b=P1sViIWe2Bh20WkACvM9NscCiAm99Fqy4TWv32bokWAg86RjBpEyaAC8QH3RTnwU+J
         Jinp+w1aKjqKnYPc9r/gT9ZUT7IRwOxfgxRCV0fKY/g1YWeMx2filCmQQzeVSAphv+fJ
         wFdYiJQ4pVgrSjoRi59vTMoqsqcjvhg/GKpas6TIC9mWl6S6OiZBB9w17VBNVO+3lKuw
         8sAXN3GeYOfpU0JN3s3M/zYegneBrcOeu6L22qlNEKocjmeo0swdirPDHINi/C5ncfrL
         XwPwqNbns0x2W7W3Gy8JfY4e01EGG2uDNU713vlOsYg7aw20CkHg0teP6KWC7ZDB7qdw
         SpLg==
X-Forwarded-Encrypted: i=1; AHgh+RqaLwEfPgvkunOgLE0S2Bn9iPM+TBRpy+Rcpw8c6Otqt8eoOIYGRKlk0I5p3AUR57gmzUtWj2Bk4A==@kvack.org
X-Gm-Message-State: AOJu0Yz7h78g9hIly2WhF+vdAFTzziIDZV8k8M0hBkz4mtnrjPdJ7uWh
	1h7pNos7AHSNWSElFqgqa0onSIp6pnQpfkEcDUMrKrCS7UKsWV5uqP3FWGjahql73atmkmSfm70
	kReCAqa61pw==
X-Gm-Gg: AR+sD133FluJLMsmQwo6blJfnB40Aib0IxQWU5vrip16S4wRq2M1/xqkwGLMSL4dj0S
	P/ffhXBjQfZU520CuXyBqEKxe8XAzbc2dlIcEPM+R1O3xj8QVk5TZM0mWnqPHgcuTMxE39w5Jjf
	8oB8LtBrgHtJoipSa28CvFgB6dpvhJiD6PqKWbP/vNtqLE0bbsT9ZJtoGWGnyH8Kp4GV/BpvTJs
	tDHtkhHlcuiBWzz5r7ACmQ9CzLVTmHK4ujZ4OIQWoRtfJI/mfURKkfTMSJ4HA2SVk36QunTUi4b
	c3uoPzj/0YFf/InvI6HYPNlBW++FWwsjxLrfBqHMelwlfWokyjxJ7M1HDWqMymQZ1/R4FFDBQtA
	u6iEzBHli7EoCNa9J+x7Ei5+YGDefWS7GzgLX0uuMIi65Z94+VQKKtyXqwHdkRLdQEAvgfWm0iX
	R6vXqfJSpou0UQhLPYDFeapAI+DNuKmeA8mTM5WJA8qpPylS+bzjicjNa/DaxJy7tNsw/bsFL7e
	4PhMQN+xd0srBd1auv8tC/DRbANnej/rzF5oCgVVQ==
X-Received: by 2002:a05:6870:92c2:b0:455:9e4c:6bd8 with SMTP id 586e51a60fabf-4590572d113mr843225fac.2.1785510069701;
        Fri, 31 Jul 2026 08:01:09 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-458f67655fesm1139402fac.18.2026.07.31.08.01.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 08:01:08 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Christian Brauner <brauner@kernel.org>, 
 "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@infradead.org>, Gao Xiang <xiang@kernel.org>, 
 Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
 Jeffle Xu <jefflexu@linux.alibaba.com>, 
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, 
 Chunhai Guo <guochunhai@vivo.com>, Tal Zussman <tz2294@columbia.edu>
Cc: Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>, 
 Hillf Danton <hdanton@sina.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-erofs@lists.ozlabs.org, 
 Christoph Hellwig <hch@lst.de>
In-Reply-To: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
Subject: Re: [PATCH v7 0/5] block: enable RWF_DONTCACHE for block devices
Message-Id: <178551006694.14426.18417795913299417263.b4-ty@b4>
Date: Fri, 31 Jul 2026 09:01:06 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: 378014000E
X-Stat-Signature: w4a413j7srue7bycycnziktms951xbdp
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785510071-298110
X-HE-Meta: U2FsdGVkX1/IMtfKVZ0YkctNKfm2V1UK6APQlIVssJPXomN3uoUuOc1KcFdjKrdYFR+3xPkgmSphAUNjs3y5YJkl4l1HUjIveqIlreLj0+dMyy5ffNBnQcxlZvNEzOyIOITCaNDg2Y01z+C4qAG4/Q3rA3L9TAFcJlv6YIfAAoxeuBUBomYjWGVb0PtFEHUFDsAX6o2AVNfeYXtdNwAWvLkPd/TgSpCeT3MgtLUKOyO8pn2C/MYh0xaugjIFu70/fjVnXGPftplvjWoK50l9csdgwCqKBIru8lEHp8MST9zIcjuqvQfCV1JcEz/DsRqefTkunZgWIcIg8spZko+3PRT/cvhqe1xohdnNyqrax4AAk5PQnguRC6mpWVk6CdTFhs2OO1Zwqo6GPnHzOfTVg1nIRTAAHnySlr2Zhfj8awj16oirVUtQblh/CU8cVWOFC5nW0l88Ycqkc4/4fJ1c2ZKj3afCYkeCOPPhFPb4955tG78lWHFnMBzvG/UZ4sLD+K1DP1SK6/sCtxV3fBW22SJSr2qWo+xGLNrlztoMZ/yyICeCgdoaSoxbdyeEIlEfYcfkHZr0AiGwPZgPLjrhSbDdWd0OAKD63cOw/P9PiUqx5mL20qhPtG8BC9b5cOqkRmlF9+Jt/ZDlYNn/f9bsdew07xm6NRhwBnJRX5iXhy+/0NBfuTTPkvTo8ueXrIjjXP/UadMqKPbH0FVhDSxzInBzETsICm3EOg0Lmx80AF4Q5fOxg+Ct+SRU5QaeW9RhJGInZlVoXFFJ4kKxY7H9ZD7aQM0X+7Eh+Af42fqqB+vBHz9vfJtYrOH98AoruDYGFn2zqeQ90p99C8IBjDLTTYzX2Oa84McyIGO/bhOdw3mry7pks9Igkd9sB2ctvRq0BK16rf5o4/5WE+baL+vqyq4P6uoDqNjZUWLhLNntfGr/393auGVKguvCzOyBvfoaXa92lW9tkTbHUf1Znvn
 SeLya/7S
 QS4nfRdvlnkZC6Wqwby83Ueu83vm1Kdttyl9h8PLjNLTEdAUaYjSHfrICw5XqT+VM9MBr0DTMWfgqY5bK07JYAJ6/GYp0ecrUC/+1qYYugQa+ac7rERY2iZ+N/sc+4GCTs/taRo6+NI0kI4sOwmkAkXXCfLo3wbfeX8qnc/UokVlwcdITumkAwTHEKVkaXCkkGqMJOC0JwFuvrdzOZ5L0FgTu9PmVlJgJY6GoEWHYlAQGnOWAxkigmgrhidhjKQWiV9yxsZ84ZUGkX9t7B8X503G+O8ezX8ONZ7owGuCR6TdrOEUhz4SvefdtDFOqVTBrCFF1VfruYdojl6an2f7l5axT9L4ugHGgYsBu/oXvVgSH3/wMSy0zHicyE4EStH5u5uNk3dz/7ihPL2qf8UMhiU9ukq713jPiXEugmmEH4nMQapir0Pgrc23U9PHTFRsIr1Sq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, 30 Jul 2026 02:57:50 -0400, Tal Zussman wrote:
> Add support for using RWF_DONTCACHE with block devices.
> 
> Dropbehind pruning needs to be done in non-IRQ context, but block
> devices complete writeback in IRQ context. To fix this, we defer
> dropbehind invalidation to task context. Add infrastructure that lets
> bi_end_io callbacks run from a worker, in two forms:
> 
> [...]

Applied, thanks!

[1/5] block: introduce bio_in_atomic()
      commit: 8ed0831b5263e1aa48d99063795a1f20e4e69b50
[2/5] block: add task-context bio completion infrastructure
      commit: 77e73fa61b3888c9765a549af02c928372522cc9
[3/5] iomap: use BIO_COMPLETE_IN_TASK for dropbehind writeback
      commit: efbde6f9f449da3306f5b5d32f08829954ffb44d
[4/5] buffer: set BIO_COMPLETE_IN_TASK for dropbehind writeback
      commit: a2c924c240e74dc2dd14ff763245dc86b93db714
[5/5] block: enable RWF_DONTCACHE for block devices
      commit: 8b5ffb43ae9d27eed9165e1962963d685d879219

Best regards,
-- 
Jens Axboe




