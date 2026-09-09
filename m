Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CEC8C79FAA
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 07:25:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 543336B008C; Wed,  9 Sep 2026 03:25:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CCB76B0092; Wed,  9 Sep 2026 03:25:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3948D6B0093; Wed,  9 Sep 2026 03:25:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 19F356B008C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 03:25:05 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9BF661C0185
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 07:25:03 +0000 (UTC)
X-FDA: 85193387286.10.77A6B2F
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf28.hostedemail.com (Postfix) with ESMTP id DC577C0003
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 07:25:01 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=i99tfjst;
	spf=pass (imf28.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788938701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6IpihIKg7y7X2cwXfcmqkmOxJCzJb7Ke/fCjIixrgYE=;
	b=EH7paNkal0BrU8WoccLFuzJfwwEPbVKd0ebIDG/KOQ/ElXmibzGDqzRjM2+KSAB85mA20R
	89NH7mhnbWRA3lu1/EMpHR1HP4AMttYNlNiqNKCehj0WCSx0dm15YOZciBgpbQ0Tipw1uL
	hPv7nPRKcYq90K9pSNQ82W5wgsrxp3A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788938701;
	b=3+bW7zvXHIH00MgdCRjgw7co8bBzzU3GrYERNcQ626ZEVitbJyY/UQeynWHTbmoLMDhkOP
	I7Da5U/19+qUWOMZvJglYGEro1I5CQbrBg5/7WBNYWZrHC3Fl8hJQ6sZ6Nd28dGMZsiUUa
	r9xY/pxEarAfhxnW+JfDx+co4OFkol0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=i99tfjst;
	spf=pass (imf28.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-485850cf499so3704866f8f.3
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 00:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788938700; x=1789543500; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6IpihIKg7y7X2cwXfcmqkmOxJCzJb7Ke/fCjIixrgYE=;
        b=i99tfjstONURZCqtmxvh4I8GQBNCjHqmdv3eTa6DG9KENmgYxuBoQtp4xfzL/t+2MD
         aXKz5lH4qJ4Kt30+sr8A5qQGROSbvgjAq/hhPjmt/N/f15eZ188rjVDBytD8XoH+4P2I
         OdkDY4oZ/+jyisIydV+I/LH610XxAYheUZamhg1Htt7TkXbIdp+/NBsz+2IsmADzWXGn
         /UHprUzoQBZwzgxUMRk5RvnPOpPREMCAVLyfNKAic9RjeNO/uO4NwTgHa3T3/AIeuAlO
         +nLaWInV2IGBNnKUuuKb+hGzM5gMBCCD2GuKZ8x+ZVl5+7yGSmNTy14/8RPYSTMeUSeW
         lP3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788938700; x=1789543500;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6IpihIKg7y7X2cwXfcmqkmOxJCzJb7Ke/fCjIixrgYE=;
        b=iiA/WuVvhE59u+FURtddBwpsWz0NZJYnWh8tgW4CPafh17HQG4N6wyzVihiiw7au0u
         jIPU8wRXfrmJWxV3J97k8KC8yV8fT93QQ08QQaosvbIcYmuAyxmV7xvRtM0Urll3BRZJ
         bLJ0fz+2takdKBEzmlnLzqNMU2NXqFlzi8HzFkkenI66du5evgM5jXie0MT0UBojn49f
         wuZdrI9k2cwFZN+/dtEmRUdo0eUtzwFgAvS2qIVgnP6blfEdKH0eWzDBH0Wqyc9wXz9B
         iuLof2LbKYA7UXSrm4LZeZoZjasOp8tS0ZffofyCJL/89kOP7sVM2NR+KkXCUGwnNpRy
         AfOA==
X-Forwarded-Encrypted: i=1; AKwUvBzAhFQlHh/ycHXmOiKKbdieaFge0RlVPnoOuZCzo/YONrPC6yf+f868JFH/C7O37KxQj92vVoVf6w==@kvack.org
X-Gm-Message-State: AFuF++lkfXSDCcmfzIxzqdRFg76WjB6hn7AYKpQuo4Zk7Rrf3nwHpDeO
	vHLiAIXpFCHKA3P0EFT/ubnhRHRiniss9AhvuVqjhCgX1874wpWxhoI0
X-Gm-Gg: AYBFou250/zg+ZNdRwdbp7DyypTZXc+ZoXSL1hDO7tkD8FHCrvs6sMMEkXd77cnYlB6
	CA4LEAD9I74RDr4jjFkCbwwqh2dk+d/Su9ezpSVKfJSZzk//xn1nVYtW9i5nQn0vcKDlwYd3Dfl
	oT7sma657flQpxm1R9n7n0zgEaN/IypIRUJFmfkWZv0XvELmLtEnSwx4xiFpVhojWntyKcRBfoE
	u3H0YawdX4BLaOGUGnI3/VoFNDdWusxrALJLNDL+C47dQ/1E0A3MFkfHC14eoQmnSv09iGaFCDw
	vj0V5EkpkqSyLVEvzYct3YZYnVLOyYAjQ6KkDF77by3llttcj2HjGwFXN2x/iz61pItTS8vyTa/
	A5CUMW21FdOD6RH60DfllNwAZ888oTtBnr3xtkmb/Hs8QRxZUQBqjQ6y80iDBLGIoehV3Ss7lZf
	EW9Cp+Sqe6j0vuKn5KJ1M4y0UbYllD2UUscseXF837yQkPVE71JIfP/5JDir988rWpzwRygXAuq
	Kyob0873CmA
X-Received: by 2002:a05:6000:4909:b0:485:8c17:9764 with SMTP id ffacd0b85a97d-4858c179966mr30927449f8f.38.1788938700220;
        Wed, 09 Sep 2026 00:25:00 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5f:900:ef25:2f4:1792:4e6f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-485883acd33sm41527265f8f.18.2026.09.09.00.24.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 00:24:59 -0700 (PDT)
From: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
To: bot+bpf-ci@kernel.org
Cc: akpm@linux-foundation.org,
	andrii@kernel.org,
	ast@kernel.org,
	bpf@vger.kernel.org,
	brauner@kernel.org,
	daniel@iogearbox.net,
	david@kernel.org,
	eddyz87@gmail.com,
	ihor.solodrai@linux.dev,
	kpsingh@kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	martin.lau@kernel.org,
	mason@kernel.org,
	matt@bobrowski.net,
	memxor@gmail.com,
	song@kernel.org,
	sun.jian.kdev@gmail.com,
	tasos.papagiannnis@gmail.com,
	utilityemal77@gmail.com,
	viro@zeniv.linux.org.uk,
	yonghong.song@linux.dev
Subject: Re: [PATCH bpf-next v6 3/5] bpf: Add user memory access kfuncs for mm_struct
Date: Wed,  9 Sep 2026 10:24:34 +0300
Message-ID: <20260909072434.66868-1-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <4ef240a5bea36ff84df9589671367832860795159386a4c8fba546a0fa8b786f@mail.kernel.org>
References: <4ef240a5bea36ff84df9589671367832860795159386a4c8fba546a0fa8b786f@mail.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fpwiquxm4hersmcthzo1hdj71w6z5hr1
X-Rspam-User: 
X-Rspamd-Queue-Id: DC577C0003
X-Rspamd-Server: rspam03
X-HE-Tag: 1788938701-812183
X-HE-Meta: U2FsdGVkX19hG3r/SRjCmQmFMRP9ezX+pn73rGpmCIv/VKYbiissIWAGyDJdWEKnWSqAGVuOWe6PKYgG2Jrp/eqLCe4mbJFXtHoud4xciC4npiaV7sD2j8qW9NIXZlrVrkzwZQuVLsvLf1k7UKTSAD6jFqUt0h++XAkdpD0PV9YaCkmSxGa9pEjSIE4x7a8ZUnCLXMarhbFRnrKbOrOUwJFkqQ2DWwm8y13lYXUqPN9O5zNKtkhiRGPEl5DhDM38IjtI/7Vvfz7lKW73w6S52j3ABhapMPQ58ax1V2TiRbG/yzuyFl5fmwz7bocIdNLrcrbb9NnWTOS4+pB8JhwdI5ENsmzFTO4jbFhOk25NSA5dAT0edi2lCBlzgMy+KUxaKzWtG8u0NCVtWoGTj7F7K/wCG35j8AKbQLgks6KVxQNe59C5S5iGAkmLO+yIHtTAEGNiBkGF6gzMzx89zd0VGioa3qzdxggb0JuDH0ebXBUEojD27h2qmg2tb2yHDnnjvZ9Et5qfq+4fV+IbzFquc5quJ1k1gRHD4Oo9eQBlU1B/y4Tp5asi0tKizfjdFYstPu370GwVfB/8KrhqPTN8U9Jv23/+K/kisgB1g1kut87rbPplzakT4oi4Lnxs32S2BAqg6IBZxc8pFV1vSr+JZdlo94JeOCZT2Lf9WxRsWqKUmFYKzugwwohhuWq5VkW5TJGiZmfv8sNv4GVzQJ0Rg6C28ZluXFSYwCHJcU+sLH5M4wfP1Ki/Ti5eJWVs0+OiPDhPjtSPOzqNmCeiE5CCAsZ90LZCr3YpxUAShgzXgfoH19ATlGggTKbNptnY6Tj3OyF+HaS5pUOjPVbCaeNwW15eqEFBrNRWtl4cffRLBFeTBfSIoiAGWonLLDPW8UPsMtfOEaq8MQ842IgV/1aGj7wMvbXfZF6UbdS8aLTiFfBD7m+eXHVFm6gexD/wEgxnsg6dpQvQcdtq1fCoofA
 LK7zwFMs
 X7fQ+ElHOuei6beIt0JV+VEyukOSfSHiDXJZrNAQrEDlQYhoiysv7JbNB4mMf6DFgnSsVvlCjUuyV8Vi8xkDOB7KlM2J6p2BcfIrw9hKB0WY51AfcGDJq9b6NbIi79Yk81aIdLiErKg8vNU83XhdsUHGzridHKHqB8zy4Uk/J4ImIxVcaiQmu6aEgIgNV3qceBJYkmiJjq8evWvoqh//ns3REWHxSeMC0gw7Eta+PlBO5eU+QZxQEpzZy75yk2XRxTJkTxu3ZS9AdHm9TdgdRGVwbxihMfJxTFnYDOCrGtKPM7Z0ek/7sG4tWri6rgBm7nsVBaTgKqfX+ujWLmMkIeW02P9ypPBp+YaU84/ZSImpnyOtTfvRkqI7J/kJA4ZmmnjJ4YI6TYtYHaG36QCfa/69BEukA9sUbH6aRNrowmWWNXwqpfRcLa9AYV5VGyEPrAE25HC9Sps7+MKfxN6ovPLiF9jLaODaO8KQiOBI5UBI0xpTeIbkJxbTjGRjYYuan5wfkz7mUjh+RDOt3dZYCOUN48laEWNuu7Xv+4+rXoxaWh67rgx7clwJJI92Nwmn03ZFw3JIJQuaLGR7DNDP45AsnhaR2H70FSQHmHHsd1F+yW2sCKms4GX9UnpFvfN+jROhf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Does this drop the address-wrap guard on !CONFIG_MMU builds?

This is fixed in https://lore.kernel.org/bpf/20260909064231.18693-1-tasos.papagiannnis@gmail.com/

