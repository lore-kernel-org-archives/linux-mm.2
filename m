Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68F63C43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 03:18:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA2696B0095; Fri, 26 Jun 2026 23:18:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A538F6B0096; Fri, 26 Jun 2026 23:18:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 991436B0098; Fri, 26 Jun 2026 23:18:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 613916B0095
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 23:18:53 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E3393A05EE
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 03:18:52 +0000 (UTC)
X-FDA: 84924235704.11.A0C9BF2
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1BB5040002
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 03:18:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PFNQNbCZ;
	spf=pass (imf27.hostedemail.com: domain of yahia.a.abdrabou@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=yahia.a.abdrabou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782530331;
	b=tsmEUpodKQjtJxFVAlQ/ZYWYD0+GFH4FFl6McQFG+LGL59Ogu5ViltHYQb9AyJDiV4q9o+
	+yG6uC496QsMMERV4Be4jIjgAxL5AioKdkcR5tBxPd0Gw+WaRCqUMv32rVl+NB39+ARjgv
	tr4+VP5pSbXIN+XQFu/2bIJLVu4G/qk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782530331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ljvVn5U1rKGfhXjyLbQ+/YPB5yROqRuH3GNe5ZkXCSs=;
	b=tyv7I7hXHxetxRzU4a3QT3jBN1frsPFJ53gvSGMbNw0pFUw1uiT5eDw04NEHaQ+mwzWFrx
	FtQlVoQwD1pXL3vtiqCyT/ArJBCdj1+VVqlZ7BMA0Kozonc+mbqBilzPBFhdGVBiGB5pU0
	xtaXPBbOQox/6S98WjfbNcTTbjrdF7o=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PFNQNbCZ;
	spf=pass (imf27.hostedemail.com: domain of yahia.a.abdrabou@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=yahia.a.abdrabou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-49241dbf9c1so13733315e9.2
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 20:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782530329; x=1783135129; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ljvVn5U1rKGfhXjyLbQ+/YPB5yROqRuH3GNe5ZkXCSs=;
        b=PFNQNbCZWucNFmNGVqupCSnpxruFV0tn8wM1u114mY1JvRcwhBzGnM+O19MF0W5DmD
         lK9eEZH09KR57okl6wV4lo6QiQ8/U5BF0e7zvG5efdPezDQhllNIP2tsCBTQnzQPuo6O
         zZ/EiR0wVjwRJo8EahpfCCjvJPXZKW9Nv06Qe11MIJdq/v/+t1SNm6MMiJrGgQcDE4wB
         H3itXn5S7S2jtaL4YdYrBp7SOUyXMQFfQEBhVvwod5VQrtkl4zA0GNKcZPfh9mROOneP
         b1v68vM22cpJTuErubRfEFHl3R8ldvqtNL+8g6N6wn3w+zxopd5WaomxmfIobrvHUwLv
         DQew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782530329; x=1783135129;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ljvVn5U1rKGfhXjyLbQ+/YPB5yROqRuH3GNe5ZkXCSs=;
        b=LRkKFV5RxSneVcRfxH+Zau1/b8ilL/g5MrIBXac1Y6jw0lJE+NpGGrME7iUdIcY4I8
         FW/UK+e4Zf5Fizp+U9JHpDA8XazqJ1aEI/Y/DzjWQRWPkJFP5jacUy7jr0RmRAEvfCbh
         jxjNH0R6rvp0EfVicx1X8XJRhcinCKITHw9GY5fxdPzf6ROK0QPPJuGXBQYxje85qoy8
         6gMGYEvzlCUaXGQeegdtlhrcdbcTtzPY1ofBei5mGODvmGtycHhpmizxjONFn9Zisyhk
         gvszlnudx6Y51bCmoy1YAJAwgFY4rZ1uQyDaOfT96T6++SEri8XqNuUfb0javebyKHsD
         CgYA==
X-Forwarded-Encrypted: i=1; AFNElJ8BHLrar7u4wbpmFGlAVdA5yV/4AYRSYUJj8Kb53LtFCX+gGRubcSNR3EexXgJPnUXNzfvpncSKzw==@kvack.org
X-Gm-Message-State: AOJu0Yw/oSO7bUo+7XiipbQWkqKIAvGoI906ZtQ+P20Q3h4VJKdHUSvD
	+4rWES0bKWQsMcynmlLr99SuW0hjrcU3oEB3M+YGouKUDmSEOM2NIkym
X-Gm-Gg: AfdE7cllX4TU/KkjTaVEQniDpE32FoDf7AzMhuDPlrH69aQ1bPVmD748iUW58dpYEsE
	GbQIIlTzPOImAZDOHSvNmxRgUZWT4C71uGg1xhWKwPHJz9DKz9okg2zR3F0wv3qLiN6mTjMJf+0
	0K3gVifZ+llnivrKi5HRahCbj1VDqmXv2tHSKICynEi9+mfOyHLRz+H3EggnFdOscRIrRSe9Ya+
	sBtAohOSFL2YVQuLDmjwvWaQ3lATmIeG7RE+tO8Atfd1dxmvL/oZBiSyXAFiJF6trFpzfcruQpR
	cYAzLs1OKbLTxKzudlu8KJvJq8tZol4pYISSVN5gdmBwSNRaioppVklO+B9FFiHW+ioqn9UPGG7
	cR7JUMDwaB+k0Dohp6JAS6LnH3wvLRiSjUCFxNVaGBykKB2DLd8KcKhg/BvQ8LiIivNjJKo0Xlq
	iUYyFfoIvjzIg=
X-Received: by 2002:a05:600c:3b04:b0:490:e104:7943 with SMTP id 5b1f17b1804b1-492668858b4mr137640335e9.18.1782530329407;
        Fri, 26 Jun 2026 20:18:49 -0700 (PDT)
Received: from user ([104.28.162.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4926c27fcdfsm98159285e9.1.2026.06.26.20.18.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 20:18:49 -0700 (PDT)
From: yahia <yahia.a.abdrabou@gmail.com>
To: hughd@google.com
Cc: baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	akpm@linux-foundation.org
Subject: Re [PATCH] mm/shmem: handle integer underflow in shmem_fallocate
Date: Sat, 27 Jun 2026 06:18:46 +0300
Message-ID: <20260627031846.7707-1-yahia.a.abdrabou@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260626024400.67853-1-yahia.a.abdrabou@gmail.com>
References: <20260626024400.67853-1-yahia.a.abdrabou@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1BB5040002
X-Stat-Signature: pim3ueisy6z4uykirh4jsect6qytzprz
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782530330-904798
X-HE-Meta: U2FsdGVkX1+utrpCrkv4UIo7SzHX0trBcOH2nXwHBbyWiZ5yhPMdtC1deXu/o1zp5a5MFb7D5hB4f5TxD/5l2QweOkxB2JiGr41ZWqMvaZE1CrVCXQmES867J4S4TFJLKqDCeFT5bv2YkEae/nzVPRYE+mckVaGvjZEmx1+Xtu9Fe585D7hZuo0RbX0LrlEQodPo/hTpNZW37KPy1tQwsOIFP8Hpzskg3IsSLSB0ury6pt4MvUPwMnuS8yAj+RoWT2khzusPdCiH95WZO+itu3x206hfyKwJdvKWDTdJUNU0o2F7T2T/RO5MzmiYyEbu60GIObdMiM/7OGjbeYGsIrDZoiZM8e1c7/HgqQX4FTdihGBzXoF7fjZHj0jIGFbuai3qPwjazWAWZFY4ehZSQqOzrDNek+uI63F+s9utMNOTKloUDfdtXfPd45T5vA7hpKA7hWjVRUi3sDLDXI9d3oxZHlYPBIMxpTJAAfJE2ETAmFpJLtjXkGPKTFRolld/KDrvuFiYD87CXzHQtmINfyKetKDGdvq+0YS0Fav4lhx7XAy+OwnjSY8MgnlcF6zmwEyOZEaWmPaK4FK4fPskab3Oiz+37KW7TyaYbbfAf6W7pOCHcIOk7DB1nsMO2/pWiRiZIrAuA6fj80Pnv/AaVie/fqi+S5qeEm1K7n+sQVdxI775MA5aWrtT8oSQfjP8iYkBDzaUJm8Ljb3u04We047r190GM2CnJbdz8Je/c0vFsSkHhghfwuQ96cEhzlqeSYHqANCdvqagI/cpbUBeryLw8gr9lB1uVroX1/z3DxsSZ7Yezh28sqbhKKK/n+SffLq/2xVk8nd37Cd3c4BVxqqEF0Anf/lhCpRWVDDkSqbaTtNCj59xn531fXbXHJC7LMvXWUxR31tobyb2Ya6iquIOszBSQjyROH68NUVhBQx9zUziz4mP5x/kM/ItWX4p5zjHovs+zFWr5Wbh/4o
 QQs5A7WM
 tk1Sv3dThwZneQUuNNF7iPcHeMhpr61LckhThgiBjgepNmfzVe/4X4Xn+WsJJ+LWO/LS4g99aSfTfUWmugRyPf5m1Xrm7jSt9whLEZfDfey3AeW5ARR2IDqrntJ/IPDPeh8jt4VmgppzeUAywoQPxNXlFHK88YqXafaUz3YRACgjBV1ZS9L/ugu/Dypa3uvo02MVq42RN4gxke2yaP/jM5bBlYao6Lj3OWzjEy0O2lNUFvfCWS9HsYymyJexTRaMKWuJMZZDdiPRyPffpE063Blruch81ZNIbTXas3pWa5XTKIsSpZFHDs5npZ6Onnxl6lzlAst39xy/88BmUl3wbdbV+Z3T+JjLqpyAXJ7KtL9Del0pZL3VG9iqYkfjGejo+wppf6UhuZF82ctVZD+HnxiLE445T6qoPi2hf2/0PNSn7vTEfk/UT8FdZwzjOLMu+8xAq0BDMNPPDFUKlRGU6oQMuYaJiuGgFteo7QGRFyROmJOXlc19MwL/zd7GdPpWK85Cg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Please drop this patch as i found
out that it introduces a bug because
it voids an intentional EOF.

Best regards,
yahia

