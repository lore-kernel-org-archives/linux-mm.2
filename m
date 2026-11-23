Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 293DC606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 17:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kv6J7EPK
Received: by kanga.kvack.org (Postfix)
	id 2200C6B05D1; Mon, 23 Nov 2026 12:39:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F6B56B05D2; Mon, 23 Nov 2026 12:39:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10CAD6B05D3; Mon, 23 Nov 2026 12:39:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E52626B05D1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:39:08 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7235612092D
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:39:08 +0000 (UTC)
X-FDA: 85467094776.09.98DC6ED
Received: from mail-dy2-f4.google.com (mail-dy2-f4.google.com [74.125.229.4])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8799B1C0006
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:39:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=kv6J7EPK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.4 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795455546;
	b=esgGnF5lWbPoRxeB1EbsGwDqTAdgaoc6rM9liHdWwX9ZP0dr90TEV/bueyqOkV3JcJ3KhF
	9GRvkA0PyOPPw82OjEwKEhFY+3/Xu1+zvRxH60Ic/gJxVoNCRS21h+eSfu3andkCpt5aYE
	QC7SR1NPH24hyE3BrEgMCV+9LKGAZIE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795455546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6/YqHUloJtkZbpJ39+cQO94H2zNky60itqgdCHgeegQ=;
	b=eSUWDyM47aB3c0BF2IWMW5lW0bNAs8QbX9lTlSiKsXCFgaadnburreH2E3dFQ2yfYr8Ao7
	ARfbSbxCb7D37Yef+56erSD+cgl7uOGwoTnm+T0na1DI5ug+GhBNi8OodMwX/YdEamibQD
	QTISGXy7ZTJikzR/ZkJzZ4fDC0rznJc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=kv6J7EPK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.4 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
Received: by mail-dy2-f4.google.com with SMTP id 5a478bee46e88-36f2f262b19so1400661eec.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:39:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795455545; x=1796060345; darn=kvack.org;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=6/YqHUloJtkZbpJ39+cQO94H2zNky60itqgdCHgeegQ=;
        b=kv6J7EPKW2dYt8YTPZZq/NffWM3oV3RFwCR4TxQQ308JFyTGtOsZt3gtvqkwVw7jQX
         2Qlvr6HSVkdv5qz7o7O3GV5Y8vWIYYyRZ4ysFBahN05GOkCzovuWR9pmHG1ZVRqSx/ib
         7TGOBJ4UfvtvA44P/L5nO2Zjl6AJMIn0bsnonEhQ06rNeLVcHvsDk8B3JTuGKdx7bHTj
         8aWukcAK9f+vBRWhB8RCPjlsX3+iIIPEJmh2nSxMY1CuXJrRe2mvCl7MSC/e1Hxbq4U3
         UkspTMhe19k+MAXx2w4QwmqB2a0f61pL9LTjgcQS0mPO7BTkSpXj5te2n4WMMoAKuuwD
         kfVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795455545; x=1796060345;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6/YqHUloJtkZbpJ39+cQO94H2zNky60itqgdCHgeegQ=;
        b=YR4SrIN8D7nYKdmgdhpJG/ehMHJDkRG3QVhzEzDn1b3WlrU95PvfaLdDGCWuY6KSiy
         IB1CdLrODyfJVNZcgPvnkeLyPPyxAtw8zuRwrz3MOyx9H/UgTFa+RzVcfWTjB/zNxGI8
         QuEpt1iDkMB/zwtPJ8x1SnG6Y6u3jUlaU5URxcfJydHXINzXFQORNcUTuWpqK9etfjDm
         WyT2EmO7BPteYVIR/NpMTbkPqq0X1DSgVt1GDtWDWnOkQEs+IRzwGk12KBlunCY2rwOw
         9b1apw9KkXN4rJu4HnZqDVmmQI5HtII60C+bHK+38Bj7UZMr3oDyydHJ/ai4C7T3hBTM
         ZjiA==
X-Forwarded-Encrypted: i=1; AL+hErFaStIFiSP2zwLkK7DKpMWD4jmFA9D2/VMj462duaB8sxLrZws70sVI4CswnJEWz9WOmRyYYI52Wg==@kvack.org
X-Gm-Message-State: APuU4Z/jjG5NddXIjg3gyEWwhLKnspmwGYCqEEc2bBLORG1t6EjIhGrT
	i7i7Ozfh/j9/nv7pV8sYEF6pNlRIIIn4ZzZLzjv0tLeGgXy08SAVRx3q
X-Gm-Gg: AZFdTZcSrFo03JYeWP1qV3gH0DExd7/nNAAHk0v96IQvYYUMgxkNrO0lcAHmVpTfQXk
	s1wkrSNxPoepABqqFrZNGBPuAt2ZkBftYA7MEQ1XAUHjPvUZfmFaYPor11x3ZwLDGhjK1Cje+fZ
	JswRP4p0bmpWCJ2Z0Eo24L2mpZo7pIA+pUgLML9twjTPZAu09w2plrN7IUL7F0czQAhN83fmMxs
	a4D4GSd+y7yF2CVZf715UmBwAOJJFrA4Q2mfGGjZC71MMZW7HR71AgI7Xj6mLARf7H04DFiDE/t
	cVRNImVBzEdxGS+0EdHLHa33U/Th4jjTre5Jy9Tc+k0uhwkajaMwb6phNuuYlIIpl04lAoVqtEj
	dJhMna6vkTYieibyHpp1Da5f3LlF50NPTeTSyoFllIHW4+tyMY+vc0yOUY7Vytm84S0GYHi37fe
	TkcL5SGwG8fTifu51mqoZjHQRamGySB7sAG+AcXbsiQd9XlQ4qmOlB/vhl9+ZzIdENtvHeRZdk9
	EQOh7QpFTDX2LTECy9IwhBvqsBem2bwnw90nTquKahyihFS324brpmvTRfSDf38YeB7MSEP0Lm4
	4kI6DjEQbYtD26VK4zh9SUMLD3XYinuj+OC5Y62+ld2ksHdWBKDfjtpDd0IB1r4el86+80sKBU0
	PiuV5jTlwY9Jk1rdXII+AFeZFm7xWR5J16vUOs+NSub7mz+wRCzQyidFJanUvGg==
X-Received: by 2002:a05:7300:1486:b0:369:d8e1:7bb6 with SMTP id 5a478bee46e88-38570e24c35mr16246805eec.25.1795455545227;
        Mon, 23 Nov 2026 09:39:05 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38567abb870sm31532302eec.25.2026.11.23.09.38.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 09:39:04 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 26/27] Docs/admin-guide/mm/damon/usage: update for
 user_report report support
From: Aveline Noir <jm5905938@gmail.com>
Date: Tue, 24 Nov 2026 03:49:25 +1100
Message-Id: <179545256509.4.13115689957500135208.b4-reply@b4>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Jonathan Corbet <corbet@lwn.net>, damon@lists.linux.dev, 
 linux-doc@vger.kernel.org, linux-mm@kvack.org, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261121210013.130397-27-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
 <20261121210013.130397-27-sj@kernel.org>
X-Mailer: b4 0.16.0
X-Stat-Signature: at1fa9pjeyujnz47iqyte5bgda683s6z
X-Rspamd-Queue-Id: 8799B1C0006
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795455546-855032
X-HE-Meta: U2FsdGVkX1//aW3bbjxeIR1SAxyJOHZFrE8z/bwCXB2l6kytZ8Tjqb2Ia4v4bU6Wm7mEPDhP7orLVAq6IDgc/ZpH0jT35shH4nTcfjVRiH89QHNAEijh695IdpomXc09Vn1cSZGEFszbQSl6Ma6SMen7bfjeoe3k8yKrTWwPuDvMQ/dQWiT3mGe4YEAHipUYiUZ42QgWsRwPl58uoNGY1e61+CHUaWaqNNKVhAmYufYMH37H/yoajqIrAg+tA9I7ExPRn4qy8fMfUk+LTnsfYTMO/2PmVNC9HHMjuOynu9iMD/SeCyKnSgd2GCEyNN25UJlEPCAO+T+90htsjo6JTFaosE/XuJdB+5L3omwW5eMrSo16cBTyqc34ednriACBfSGi0Zls62ET/qWxJmO5rKUG22jupZ2OEJzKgLuVx/d5FtjMSzqmX5NRBcTs49ScgB9Hb0wewvFgeNVdhWCcc4y/9gdi6pqaLxqquOU33WC5tD05jkLtu0SL+4n5y2ERKiVTkD05+uE9ts1Iq0G96AhggcaDTUifycoPq3VJTYxUtVjDSb06qXKeQ8nnMHinWE44iJpkchfGQ7RV07Swmrln80Nrr2NijO936M3P3Zb3md4oW9Ae+Z+iPduTfpMd/4/QeSn6K+k2L0a1qx7PtO+sIIUG34DV6OfAPhg2yehk7xuxICiyTgJ1dmYqXNH+iv6JWNq82a/qmEMfKfeYZ01n8AEFwLV9As/SpHMSr287pbdWG/ku3Epv1xVRpgBPHm1wGixY8v8ECx9AfTLeKO5IcxIFtY7ZjtTsByjet9zOqDs6gW9rYHYpxGxGWpbbktgb3uD5gQtrz2ibYrIhpoT94QcJFSd21rtOy8uwYCGwCPpfjFox4gfr9MFARXveOyRAPt5WiXaYcyhQ3AiNoOsVc9FqhUrGGbEI4xTAyirTWEKYx4yn+8I6cmhyxxXn5smqD5jaQetqNHTNp1o
 zgegqOP2
 J4j3kCkCCAprkrpZvXAfxGde8TBd9UN/kjivXzQav5eGJU1H3k4FkwrtSgSf763X1zAhAkkSG04pe+0LUTkroNbYfC7FWceJAcr9hfi7buQFthNKjoSoWPHCn13hjgs7tA9O5xqDJUaYTm5Zd1LAq69ZzIhxXvKZ9ChTXpevbeFDaonuO5QiXUkomLcfTIlnM1SrVXj2bM7NnQGgh7Ib0jVRgJ2Cy5SuXKBW1jFltKDEp7rEWc6Cit/DvIijbcSs7M53xzH4MpBHFihcg+rLnfsFDphnpJqP4M5VGwSlOzZ1gXP/3VRGtiL7Sp4QxiLjPRRXIP69MkapFUxYaNixzlsrAbpK0YHnSNwNwIbQhskyfYUQ1uirjIKW8nmW5V0qJC50uBMOPx86zqOzt3JB+Ct3V6vyQlL2h/rba47Lh75tuWZhA83kY12mcLKtlaG0+/p3mCK92SaHy/5mTGs7CtIuSS1XqFYYHjck4sntp754/kJztZz9ZR6G6mklSTuLwapuaLrgHPdbMFsnxCwjdyUa3VbV/ESjPVC+/rQCiHMZCI9Ygm4XlvtvExk1T5MQJgOL8UhmvtFb7Scnl06g7yeUKwAmHF53eDpGmOoCiVtNRtH7fKTk3nRYqUJNhSYNupoEBShwB4UZ5AEtnuvwLZEZPg28wcXTb7SVr1/6jYwR7/kvTdYOy7Tkp8W5NS/jlPvYvtXpg1ZTazLvGhlEymH0NcisSJadaA51hgq98APVZhdaPwrBJaQolDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Sat, 21 Nov 2026 13:00:10 -0800 SJ Park wrote:

> Update DAMON usage document for the newly added user_report type data
> attribute report support.

LGTM, thanks.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>

Thanks,
Aveline Noir

