Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC573CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 16:25:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 102868E00A8; Mon,  3 Nov 2025 11:25:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08C528E0057; Mon,  3 Nov 2025 11:25:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6FD78E00A8; Mon,  3 Nov 2025 11:25:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D09C38E0057
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 11:25:29 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7E1261A025F
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 16:25:29 +0000 (UTC)
X-FDA: 84069821178.23.6D8E35A
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8FAC3A0007
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 16:25:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BMjLpUht;
	spf=pass (imf15.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762187127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LF3gL9UIYUJIJ6CLrBLKlGhki20XLPHsMgj4XqFirso=;
	b=d6POi50lZ+tq2lXVC/xzxMX4POgegYp1lnBM77/TDWOEsLFQZSCrHFU9WWDjZe2fmYINjB
	y8TKpzpiTMn0pH9sBur4l6MTr+3u6aHEMDHC8zwvB8Oi/LcX+jIzE9R/lfdZH10w+0Lq7l
	nVeqi+B1oS7V79tpjyRxMozV/9L/Dlw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BMjLpUht;
	spf=pass (imf15.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762187127; a=rsa-sha256;
	cv=none;
	b=3AV1h1zTEBRioPvk9bVL9r/3T5Hf5B68EMH+5AFfgvIf/BhOhnM3DKGCU3Yrmz+XMA0KCf
	je9bXvcp493tyMXF3iJve0bpC+MdqcHmenZcSUeUVhQJDL7/3QUVpV/iFAvDmYdpKoCX2u
	LF5pju7CH5E1Ummg0Uz+lqYFkQFYN/M=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-47754547a38so1031075e9.2
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 08:25:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762187126; x=1762791926; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LF3gL9UIYUJIJ6CLrBLKlGhki20XLPHsMgj4XqFirso=;
        b=BMjLpUhtCrTjzt2Q0XSegOkU83SOBRvrPWgC0szCQVMEQKRba7xp19cHHVPxzPE1W+
         4BwxJcFlFvUPs0vQ+8zF02lC5BxAIHTI4ZJQ/0JBArQMW14Gq4s9u6Jh2YlLPx7zfJ+w
         HpnI/MSMj60lVkDAhNkQZsQHW5cQ8TP+wjlQpM45KXtrpcvbcTTNiYr12SwaNcmBynfM
         cj6Jtj6uJ5OUNaWmC3BK5AdyW6uX3aD92TV1Q2wqAF6C7oVHBKSTgHVmCM8Trugcx4FZ
         QAw6eiMj3GDYgymyA5TQzCZdDgW9B5fSL+VR9D7RG21mxhwGcWHvqqj8Wwzdw+YbtOSQ
         bREw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762187126; x=1762791926;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LF3gL9UIYUJIJ6CLrBLKlGhki20XLPHsMgj4XqFirso=;
        b=CRvxBRg92sc+KYXO6xbPywvc1uorco2LsU/AGteOZU75cGvX5nw4GVf/hWXZ/ja5Tj
         2a4qu+2K7zdTWAzTEjMxQ7pkqDUE+PL/MEDacsSbl6rRWuB6s/CWbr7tMSfIV5iQ81JL
         EyV30G6U2ENtY43SeDL8gkk/1QDSX/o4AFcsjG13TA5eG2yA4r3/jBgOFtgGSOLQdqGl
         yJM3BEubc/xuVM2cb1fk3Yxe6kiMUDcVVJ5P+XYBnqdSV4AlV8amRUPIwsWPUTeQgoa7
         tibqMDnWeCZ7AjhewBxDes9zALIV0ukPaW4RUCsynxdpgbkWuvPmrKVLWa/Kpw79+iXi
         hmJQ==
X-Forwarded-Encrypted: i=1; AJvYcCUgW0DWEfNzWUuXoobpYd1fW7QAflyZr4S7u0JwxMh6hfskAWI8JUBJkIuMf/aPmb76zMtzG9kkrw==@kvack.org
X-Gm-Message-State: AOJu0YwOLb89mKComBc9zlI4sh2BwAF9cr3sNef0cSjt2f1SfEFyE/n2
	Pg6NkA0TPUdbGEKNEndfdy0V0rAZUSy5/JUdI58egi41DTQZeceo4Ita863m0PEp
X-Gm-Gg: ASbGncvyUxe34AZgAsrhZUOhLow5gBY9xXM4+j9x0/hHakky+cRcprFJG7rxqv5erLf
	uYlSMzZAMbiOD5HzLQR6EMfMbgjDfsq88neQjtDZnqicymiFp3am/5QnbrPweW+M0q+QGYeDIZi
	IbzH85TvPmYbLKjzopnbJ3vv4+Yo/DpF19kklSGYdjM8IHeMnhEy9S4Dcrk78ug2zBtbRgPV/np
	JQLZRVDAuXXeqBxnaLnz9wz8+LfRAhb5EzRvnY7QR4GseU7osnCcT3QMpOF65QpoFjGgcxckyCR
	ZvAZYS6FaS9FmfQU3ihkZstf+mYY6EO3uoH9Zq6qY0zyUR3oXm/2B+YCAMlv/GB43TYfB1X3VOZ
	8LJckW/xSSn+n3w6XE5ig/IzbIjtLWpxvAtGqIpFV0kotbpXW4CmaXdgyjUt2usu+mtpuSy1FjM
	5tj0YfmzWhL8aiHqb4yn92cA0mrIT4KHgkZ+HraGdZcjeoQJpXJ73a6o09YXm9sQ==
X-Google-Smtp-Source: AGHT+IGJUhjtjrw4JNRzbxH45JTjp5ZOtnw7BrJ7Wa7zYRDEN8vWYrANkKFN3fi6lHAq+b96Y7nzHA==
X-Received: by 2002:a05:600c:450e:b0:46e:394b:49b7 with SMTP id 5b1f17b1804b1-477308ec10cmr134660045e9.37.1762187125699;
        Mon, 03 Nov 2025 08:25:25 -0800 (PST)
Received: from fedora (cpc92878-cmbg18-2-0-cust539.5-4.cable.virginm.net. [86.16.54.28])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429c13ec105sm21666274f8f.36.2025.11.03.08.25.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 08:25:25 -0800 (PST)
Date: Mon, 3 Nov 2025 08:25:22 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Zhang Chujun <zhangchujun@cmss.chinamobile.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, linux-mm@kvack.org
Subject: Re: [PATCH] mm/debug: fix missing space in case statement
Message-ID: <aQjXckc1M3L3cfJH@fedora>
References: <20251103065910.2196-1-zhangchujun@cmss.chinamobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251103065910.2196-1-zhangchujun@cmss.chinamobile.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8FAC3A0007
X-Stat-Signature: o17ncn8w9zh6n4ektgw3yqzbn3tthwe8
X-Rspam-User: 
X-HE-Tag: 1762187127-519084
X-HE-Meta: U2FsdGVkX1+GmEVNO+fWmoshf0FUPHd3oHmhwjXu0nPc4Gdf4kI/+WcFKvJFb7+Pm8j2uLWtb84U73opI6DYL9i9gWHWmSStstxaMDGopH2z165DFSCGQZjo1xRl7Is2P7YYyg+e4hTBIZdWzRxFirEgDDJwNm2nVt+m3vJ3YtzyIf4O/o/l5kOvN4deKf46ptXJ/rZYgSg2tpbjlBrEWKDOkhk+SeznzLjJ0Ptkpry+Z839J4S/9M8WTbWrvjv8sE205rLmU+Si7tHFlF+TDiQZSKmnD5D7wYqVtCSC2AlYoffZQN3v6cijcXfp0OqcdtKH5PjyT5yftiJnXOVKCOonHDR1tpJnGVNBRWcwBkW19wcAGe+obxYexklrl2yIWFFfy41fhz5LmMy6XDSwGKq7Bn4WYIN6VuDEeLQvjL4u7V9dYAPkjgyhyaUCERnS6suVuCI6Dm4AoG3/zYhMG1Pc+7pDTbZZEMifhPVgfULPiYELqjqCv+rBkj3wn+bRSaGCxqLhX87FtlEIBgzQo8bHG47uOhIpjB36XHNveqJEpdB6EdWY/ZEDsz8dCZaQTrz1rWJUfnIAhII/GjiKtLd4aHAICvlO5AHiZDyr3f1zeneYqyhbvgcJ0da9PeGDE0knQeXHEvUBgAHYgYRNz5k/PiSYfaFrmi8B7F3v2QQNeXeTFbrOBOT4RuZFHV0rxe4vZezFd0s40K1bOJdDXYcrTysc+1hmi3Nf/brmQYgAYeY1/xsxQYMAoqDg4euQRpVnBbZIfn1nAJgl1VzTt3jqtRCyjmEhrbdHSDZOBwoCCWzDYZaAqbEQhFixZpWFRKePGZG2H034+zNBH0zgys2CWFcr6tH7JMvqf401/TxqG7OV4J0ApmoeSJVVfxO25IsYTdglOYr8cml1vrw8a9rxbZvz11hzQ07wG4iU3HKTIdzVqn1m51PLidkvvwYIeUgTTh41Y/FbV6eKKig
 x6Wp+Xt4
 rKxfcXaBKYo1Jrz4W46ONnPj4wJqhqyrWJ5u/An/76x8Kf2552gFFCeGcmlM+iMehyrkfxHq6sopgGyE3cqttSOG8RLh93iY1iMoJkJz5UHGu3HT4QxGI05J87TgL/nAagUdH6GnWGceSWOsIiRn1iaPa0GGSWDzRz5BcTcwSSD80xR7lm4o9jYQNBLsgv3Mvcd5PvjxaHX6i0wObLHwswfeT38rzPCQ84xB2vCoyjJZa+U4YQeygjsrKrbDSGtZvp8DgipHC1xbcmFkIpcCakPujbAEhAWdLlm2+4B5C3luzakyumn3wgVXrgThMOtS3UDcUDzy952+wM6wJHfsNeweH/rQDagJ3oJCF/9ci5dqfXmTp2JlCBEcFoIHEI4K34bC3xAz1ljS7wxU16km3kHuK6zvX3629wmeayffgnIK/BsEul1G56DHo4hukVz9tlWF1INOolTB7W6rjTPSIADWZT6yyduvHgOoU6fhyQcA3T/TZ3fC2CYznUjRWiGcxQVZy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 03, 2025 at 02:59:09PM +0800, Zhang Chujun wrote:
> In the setup_vm_debug() function, the case statement for 'p' option
> is written as 'case'p':' without a space between 'case' and the
> character constant. While this is syntactically valid C, it violates
> the Linux kernel coding style, which requires a space after 'case'.
> This patch adds the missing space to comply with coding standards.
> 
> Signed-off-by: Zhang Chujun <zhangchujun@cmss.chinamobile.com>

Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

