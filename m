Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9941CD66B9A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 20:08:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE70A6B00B6; Wed, 17 Dec 2025 15:08:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBE4B6B00B7; Wed, 17 Dec 2025 15:08:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C93CD6B00B8; Wed, 17 Dec 2025 15:08:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B4D6E6B00B6
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 15:08:47 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 76870BCEE4
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 20:08:47 +0000 (UTC)
X-FDA: 84230051094.24.21C68F7
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	by imf28.hostedemail.com (Postfix) with ESMTP id 80E70C0007
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 20:08:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hPLNZySj;
	spf=pass (imf28.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766002125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vXsG6CY3cPzNwF3OKQzDxWxdwzw8a6zmL7Xx5t/qY3c=;
	b=Xy4vfmlgBAwyDM0jU55ulkg6MF5kCu802hiGtgu3tsk5AioqAFZQvJ37JAy+cvmPVE8dYg
	mW7gDEyt7Q9mIs3Zimj+G+zMxUzyTRNh+mI5Kas9vgy9azJy3YaKjmvA/ma+MTGCYEQHse
	Af5NRBmye1E03LjN2NDJqEtBR1nmZ1c=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hPLNZySj;
	spf=pass (imf28.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766002125; a=rsa-sha256;
	cv=none;
	b=1ZDXt7q43Zd14RsHpDVmwMCa//Rw++OZjks3eNWA+Uy9pLwhJVu+4ruZwZzFlmLE0tkUcU
	BrMWukvGCo96daovdD2mf5NBxXjyrWSg1O5YT8OgwzL4F5fevnMuCD0vTqIkPD6rqit2yS
	mJLkDR3lrvV/PB94nAv1arwKRDO/i/c=
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5959d9a8eceso7544275e87.3
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 12:08:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766002124; x=1766606924; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vXsG6CY3cPzNwF3OKQzDxWxdwzw8a6zmL7Xx5t/qY3c=;
        b=hPLNZySjEAJs5PI2NaeIkAd8Ki0hG7LiUQF0AIzVs9KtLt6+cNPZFWIWdiNm8uUaqX
         gAtNaaq7uI8cbW02Haerzr4JfaG8SrO5OlHoFKH5kU4lTChyuzBClvySVANSLwrICjcM
         zd2YWaHknGwdMMecgOrO3JhGOElNtWIzNUx4AApInOjXmOd6J/s3aEJHxLnDqlFvZxqj
         6WpCrzw9GfVqnLG1PIEazIiWlvL+KPXy7NENNzk8FkwfCAca0zSxebs1LNa44cCBTb8W
         Df6as5fpG8EvKvS8P0or4NQq08hbKjlCyrVQrnlON6hEOcQSHpKeaMbfcuZkaC53BVyb
         tfEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766002124; x=1766606924;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vXsG6CY3cPzNwF3OKQzDxWxdwzw8a6zmL7Xx5t/qY3c=;
        b=YSgh3WC+VYZR5QojCkyWYdpFBIpWcLhZTKN+AtBXrTGPqbPZfdLN3MwH8Rd492Hmm5
         lZOWYV4LBgCZLPu4VSTBYbS/YAklO42sYDKEFIFJsZjXojDzx0Y6UULr4ITTyOIgSiUI
         WnjRqH9OQesB972QE3R6mP5bW49R6raxE+3XW2A8BDENjY/obloLwK3Ps9Ilv9s6i1+G
         k87fPvIxS5M6nNuo9zGLvep0eY5BQAwQuRR4GhW8XxGTd9Y1kuslXqiVhbYmhMw7P+Sb
         g5FjsX+UZ3r1lt+Hd2GlsmN7NO502P4BuTLmk2j9WsH2jrbk1MC4vmjh7gjFSTHdUsnt
         Xr8A==
X-Forwarded-Encrypted: i=1; AJvYcCVsPMD1TF6DisAgHgNZBLjSnMUDzGmJyUdsCsoqGlfUdMVu3PRRcPdTN1urcbq7ICYigHboxSDpug==@kvack.org
X-Gm-Message-State: AOJu0Yxi/4RRLlnxmCqu3OhIjuVhHXZq5d3hGtGXOroD74GSAPUdTRuA
	XvroAfREDM8ZXDYiQWKpZ4K8QOzDhILYmYHZ9z/rt/3FEXyDhiYmu2DU
X-Gm-Gg: AY/fxX4xwBuC361GRIGiNh6cRn7rMrlar8f36TVmbdQG0aaiGVPw020JFU8Klad9IrZ
	/2zOpef9moj0uNApMbtN3YiaugRuzqgZ6dDQHnOaHbJ4GCfjOh0u14rnNbfQR58UKxp0bUVrU2w
	MfrYL8cz61N2GZM7YYG6gXiHs8+FCJmMD3Xd+pl7Q/jVv4NQEMvbQOjC1NFUegaG73zktAMfXfn
	1jxZlhgEYxzD4fJZK8fs75kfRT5HEy1T8IHHSg88cG1djagKkVtnFlncAAhmnZihetpF97rPARw
	oau4Q+zUeG6dW0ZI8s9Dn7IVUP1OVeMiQ8L+aK9mwNbp2XNNzneOP3CVAc+93D5Majr/hnOykj1
	ppOy+fjdHMD5Jqk41bIZH7CSz79bkGACXX4XXKH8uSccNvmBPG7Q=
X-Google-Smtp-Source: AGHT+IEhT9fYz1VZZG4mXbiTxze7+4QQHlm4Yi9NtlMhOikps8yRdD6fDTdul7eC6UeoL5HfsS5wfQ==
X-Received: by 2002:a05:6512:110e:b0:571:8fad:ecee with SMTP id 2adb3069b0e04-598faa4e13emr6899803e87.21.1766002123408;
        Wed, 17 Dec 2025 12:08:43 -0800 (PST)
Received: from pc636 ([2001:9b1:d5a0:a500::800])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59a13405d1esm73340e87.60.2025.12.17.12.08.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 12:08:42 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Wed, 17 Dec 2025 21:08:41 +0100
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vishal Moola <vishal.moola@gmail.com>, Dev Jain <dev.jain@arm.com>,
	Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] mm/vmalloc: Add attempt_larger_order_alloc parameter
Message-ID: <aUMNyfeoEh_tJHpT@pc636>
References: <20251216211921.1401147-1-urezki@gmail.com>
 <20251216211921.1401147-2-urezki@gmail.com>
 <6ca6e796-cded-4221-b1f8-92176a80513e@arm.com>
 <aUKb1bL7CUcCWi8V@milan>
 <0f69442d-b44e-4b30-b11e-793511db9f1e@arm.com>
 <4a66f13d-318b-4cdb-b168-0c993ff8a309@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a66f13d-318b-4cdb-b168-0c993ff8a309@arm.com>
X-Stat-Signature: dh4d4mz7i657r78qyzad9rcso6m3pji7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 80E70C0007
X-HE-Tag: 1766002125-310607
X-HE-Meta: U2FsdGVkX18SkoybhmzaA/53s9tClYgY0Lx1voDK0Zw9w+dC+7QQ1ZXKdQgv5KHA8cLrcTR+nPmxMdQHb95eYvz9w4a2zioWdXFwfts5LDTZiQRfGBJwfgAmn62pdvnS1IXONkiPRHD0c4eapGMLov2hGD4Gps8j5e0M25NWNk14gTTWkbbzjXMpdRhF85oDGJbHvQYSydPJm2HuoImS4laFCKAupsMJEmdsyLAMlT3MKrEBfqRyouYw2u5RnEr5MOALt3itz6wyUxxRain7k+KQfa1sdfrSRkUT/ZeXkUxqzHJrFksrmUKEhwxTYNKCNSIJc6CaEEzwc96xo11haG6EHV7PfJwbVrAsj/BIXLP6PQjwUpzGMNlnflb3TptlyrVA5Rql5B39q7TqcD+lgVwfLa4nU5fUy99l4/4GNd3Q9ei8QMcrCSG5y8npou9wAcMS8/DkjW0HIW+5R5/RHM2NDJ70Qpzd6Q+sQqfvLBmKYLS+JhejUeD5+sujaYVaIC+kLZeYJn3JVjEHHL3S8BiAFmA4L1GyOOlKTc1OqSGaGgJoeq7FZGNI6f7LX6dSQkwqFr/fbLvwMw74kRZGDq8pmL8NHT7AtT7JA7YhehYLoe1j3tBnBbUfxeL49MkVACY2WSyb6TPCDG88+ppRnkzN2/lqw9rHWeAwcRPiS+HJJFaASfDnaRYy4S/KYBRTUvLfjoxr8REDUB0AzhRZWeqdgi62t3uDpPrJNgUGOLlJbVYYF7JeAOJrPkhoNnetLP+geef5tTSWovA4bVS6WU4mMYQIoQyDN3AN2yKt5PZLxE4Kp2ipzYMIPbuKoARNOdKxN42tt62iGP6W2jTZm6e6bK7Vo2a/yahPUcwA75qbuadY3KaHOr+jG5I5j7b/l/MLJHMUSbK7koPMSHTpT8xanKVEuZL8zxAHZgABYVBLCNSOfaY6BejKCF7GNc2NEKn1ejz+Af1E1I+Rv5R
 GkX1A2Va
 xgwrK01cXZherMPot9lltsnxmiUpa8dMiWhBvqI7JIjrwT8k4B9NqhgXvFVNUeZ2MFZgjH5sYV4lQM9SNmzxPEY5WkUS41qblsQ7I41r+iF3n4M1JfHrimjHhIBuzGetrbK0HV2y9mgyNAPabGNX1GvJ8sXATpXa47pJcLxF6VStFiOv4nn1JrnolnU+UzGdkx8OQvRstZNET5ulfjD5ojZFlBsRfkwsQrCH6nhlB2XwDSqBGWsHlyuZZ5I5aBCrusjQTmXeLCFlZ+jKYVUIYUCBf/SvicavcDsQyMD+SmgAn7NBz74iehc3yFu3S8XgyJr3PJn78XpYAoHOxWUhPs52r5kPsuGmVeDFZpn4qy2A32cH1hGbQGcomSGkLA602dC6kAChTV6eyD5qJCaiazvMcyVsPpSYPjfcQ9FEpwo6ogJlChrfy702+HL2yRdzcrv3wVEDSR9ZOLaWo0EoOsMKwCsnwPYL8nM6k/C00VauPbCjcNo0aES4TCPWq9SSfhlRrCskNfoN8QOm14skw9h5hV8c0uwGq9saLy3beKuA0rQJXzmU6BZnPXOMWmZhMoq7ru2WBCpGWcl4x9UlZA4q/+g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 
> What do you think?
> 
I think with such big improvement we do not need a configuration knob.
Your change will fully complete Vishal's work, i.e an idea to allocate
using high-order pages.

--
Uladzislau Rezki

