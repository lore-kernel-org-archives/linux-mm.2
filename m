Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31C94C44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 23:42:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2EBA6B00C5; Wed, 22 Jul 2026 19:42:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDF116B00C6; Wed, 22 Jul 2026 19:42:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1C286B00C7; Wed, 22 Jul 2026 19:42:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ABDEA6B00C5
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 19:42:32 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1CF7A4033E
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:42:32 +0000 (UTC)
X-FDA: 85018039344.23.CC170DB
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4505240002
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:42:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=p2iOsYFr;
	spf=pass (imf04.hostedemail.com: domain of mahad.ibrahim.dev@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=mahad.ibrahim.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784763750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UGL6nXZl8f8Lu4XqYJry5UQEFN5JCjGGk6rHAeDXEKg=;
	b=rdh8jZvkRkGAU/vVLHJNnWUyTQZJxV0rHOMF5j2OS4/Zg2O3DCHJw2mKt/UY3nxW59HIoe
	IDXivMIiZVCNpz3qd2asHK2BZXPjRz099YyUNIAFQUA9W1Dbr/OlWnBuYKAbUbLQjLzVPt
	kwDd3/k0jv/R3t8n+ZRGiyia8q63nU8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=p2iOsYFr;
	spf=pass (imf04.hostedemail.com: domain of mahad.ibrahim.dev@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=mahad.ibrahim.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784763750;
	b=IFKquN1J7xMNKPU0xs2TGBOrIqOx2bL30FyIRzRo7eth5ChmGpCr/NbC2T8Elb/cERtN7D
	Cd016W1aVgRbQV+p6yf9iUcf1vC7xULvO/oXEn3HIT52tWXT7qvSPeECBqLJCEinvTkXoS
	fU/reJqFVl45gA7ZZ8kVM3P+lnYbOjU=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-47f3b39f2a1so6008f8f.2
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784763749; x=1785368549; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=UGL6nXZl8f8Lu4XqYJry5UQEFN5JCjGGk6rHAeDXEKg=;
        b=p2iOsYFr9vwwdoDSR2CxN91sjkMCoMz7+IpGU9cuzQs3pzeZvnOAghfYr53CpRUyod
         TQAO4RaCBWfT2Dn/jGzOs+OdcUEKDrKz171JfAuEcKoA12CBREzPTwioGiza0J56uyN3
         cQtMMWYZv+QAvKpsjhA7eM1mIm3LrGoqeIn/1ycCOv0z2jTJ8oMTkz/bCHBKci+PND2S
         MJ4GEL4a/HfhHuF+Ij/bU3H79gjeEzL4k6zt0YtoPuUiwf+CaFjY3E3MNkXJrcyBHam/
         3ZpHGsJpooJZ1BZK1uBofY688VTT7WhpL/yS+2Y+bMdrWl8+bP8NNpewtBFOAswo68kl
         PM5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784763749; x=1785368549;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UGL6nXZl8f8Lu4XqYJry5UQEFN5JCjGGk6rHAeDXEKg=;
        b=bwwY87nkr0erTBVafD8y8igyaAxd9wdJu1NISWmeqeoDGVS9+b0/UZHS9knlI6qycx
         YA+I/JqUYRzj5HqWr6uFYi/XQTe2fYvfBbC8SqvfNOHwshf+pNqShh/VgAy971TxL3h/
         kCK0leqIUut8J+q3KpDWRtWG1HOdGi3h901NYCLF32+xrM29gVoF/BmRIuVBoYN+b7jq
         BVte6xJ4vxlTw+XHBRQI9WfwryoEAuGcw1wOmemmhSc1ogJysf6mnJXN7lOnkwXMtnIw
         2ftJI3wuPNP8ycEi9DvafU66oZ1ySUHs+Ij7iVEA0Y7WFJWKvRQ88Sb4sHmSDiBvIYQF
         S+wQ==
X-Forwarded-Encrypted: i=1; AHgh+RoX0nTeYSD5l300FmnnKq2wPyX1syI9YNpHBhgA9cOWhcuj5HNd5Sr2XdtIOBxa2fM7nOsSHw9U5w==@kvack.org
X-Gm-Message-State: AOJu0Yx0YYtj5ZFHg9KdcnstnZ2K1SoCa2WHrrCjGOcRUSwTYiEFOlMN
	j41Di8/Q+VfW4Evky3+rEvvx+l2GL+9XZHi9jfQZErDyB0S1TVmi524w
X-Gm-Gg: AR+sD10oem0u1lYscCpRRh9WRMA7tOaWYGq+vOYbKTyh6GV9wahalwBcOf0t6TdiA2M
	rPtt/+b+xBenCOsrfQBhFpKYXJ4RJPaCScen05lMKaH2lYWIpo+6MtZcXRaWggrN1SHmLPFdEcC
	bxwutUuh3cJs/5d+OvOeqyse3JoiW7j189THEq+BIaf3DJtYFj/BY1Hlis/Dk9KbCAcMdngCJ8I
	IEB7uJ5d4r9q9aanAViU9AOAGm9bMFFyQznCYAIChMUoNiCGTBT28RmL6dc1UhWyQeUZdmB3ddw
	zCSyCj3dGtKC6Hu67iFkEqxJGdF5aKNAV/Cm6IYzZeT2zolJc4B7ko+BO8IqAyBy0R3fml8I/Mt
	eBF6J9z+wtdX3bNNTBeCv1tQh+EdZ73M4l4BdY6HmovnLqUCSckqWU7HdJ207ulSWort909Qtpc
	dYTuSS8/C9
X-Received: by 2002:a05:6000:41f1:b0:47e:1d9a:1123 with SMTP id ffacd0b85a97d-47f8d617d21mr996362f8f.3.1784763748822;
        Wed, 22 Jul 2026 16:42:28 -0700 (PDT)
Received: from localhost ([72.255.58.127])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c6f076sm10286837f8f.34.2026.07.22.16.42.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2026 16:42:28 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 22 Jul 2026 23:42:25 +0000
Message-Id: <DK5HY1IKXNC5.36QEPX9H8SUHB@gmail.com>
Cc: "Arnd Bergmann" <arnd@arndb.de>, "Greg Kroah-Hartman"
 <gregkh@linuxfoundation.org>, "Mike Rapoport" <rppt@kernel.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lkdtm: use kmalloc() instead of __get_free_page
From: "Mahad Ibrahim" <mahad.ibrahim.dev@gmail.com>
To: "Mahad Ibrahim" <mahad.ibrahim.dev@gmail.com>, "Kees Cook"
 <kees@kernel.org>
X-Mailer: aerc 0.21.0
References: <20260722230246.2869-1-mahad.ibrahim.dev@gmail.com>
In-Reply-To: <20260722230246.2869-1-mahad.ibrahim.dev@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4505240002
X-Stat-Signature: jansw8urrhx7qe8mmh8iaejfz6dx71jj
X-HE-Tag: 1784763750-873838
X-HE-Meta: U2FsdGVkX18sTCF9ZGlADyOalzdUTbhX60XZNUl1iAT48G6a65YIFNCe2+1pXi2QZ0RpS978u/hQFx191BXgd0udU5YuM7rfwG/wXoX0KjT8ooron6qm2DcOpNgEdsldXAsbCQSExTGcKlgIVSSg/zZZltBSt+zKeYwd8eoTd0fcjXfKa99IQQNKi95A29a+TAG6a+Kn+oEJEOmxKDzbxvx++yOmKGuWS8drBR5NIeesTR/x9VbnxOdknCsPNnnabsvheWVpgGL8w39tHyUKOrGspEOfmXyDWr5ykfyitt+CiMwMXLDSS7YNHmGeUAfKVjv8H3cul3+pj8LV2hd3a0jKVO62fCt4BPe/YDlTc28HIKzIxo/q18uTJ36jLb7QHdnhrCkOQ1tpjHtbH4+XXbv6KNvzw74auKfBrbYtdXvxKtJqdkm4CvyR6JSH+z69gKB/Tz8IRpI5Vr6VMrweMjYcdXCHc4Yw8MMiw5nOElzlDPL5avJa9JK75MXFQPGQQakABdj70tzQDZliW8Ecf8E5l9vXERQZJp4q05gv2ZApN3hSYi6Rc1s8A5XzK32ERJ6Vrgh+ao3cJHMCmWwO5qBDNiJ5SPLoNH8xUpQpmIQjrZZzgfRJbOYQMNrNRO73I/r/M9wqo2KgxLCJ6NyliBDtyun4g7bjt0bhODAFGbvjLYtoFYoxaDdL/Bk4c8hM8xZ/bAA+LiEUZcdu5AtUir33xj2cUqFI6JKw0FachOeCP1lbqKi1m7GxDSqzZYREFyVuIeybdujgd5ILlCkf6CZopmOp1nX7NGAnmYzcl/SRyXKIc9J9TwK+KGVinlhhgQ0PfvR9lFZtCED7xuUW0pjVtow/bXI3whMf6FtTsyA6B1IwCVTA877aaWjajGcD6qkJ2DtADDP6xz26Qrk4k6iTRTuxT9tnzibTkRthl0cHJhk0q+91o7hrOgDm2lmS3VBNko51M54f9JAV/WK
 JpzLB2Yr
 3i7NQE983Se6O6YE9qyCHGbf5Zqo+OxYdkBslWn79ccxNBdalpKcxyHMhQ80t1SttMkaPwubjU0xGTj5HvTfgdPK0y3+w6OezSsCVApyEypG1iQR6OljoKizTnkf75pplevFZDL5onhd8yWoALsbNBJ/tmse8ny7x0if0sbE8WMSEFc97fkZEzD7cCeI3F7AL80Fh+/iooGepZHM8j27YFDmznBKBbmdOw9NX/dmNvZbF3CO5tUbKh9tdL5o9/0sqcrHL1/F1vTRQYGhpPDK+9Lr9GXcP3ODo7HGMk8AWcDGvaPW7F/DaX2X74LTOye9k4Wv/E8tpdXg4zhirSb5nKg4Y0kp1Di5Yq5AeyfsTzVdFgh4jURjTAYtxMm8bbxIFmPQkFx+7AN3wMLt5CeGCM/+K/FAdQ6AAXzDh4Q6vQwSnnK0TOLUWDtMRqE08aXZ1i4Aqk6HDiMeuuEPoadc/+jQxUUbsy7dtTcv+HJc4Vf1vo6DlhboYQFAEptyom2Czunf+8z3sLKKtX8PN/x4K06L7Yy380zfgzVaoSOR2O2CSGjtpz4ByahDuL2t4N4DVKTARW2NDI6boo0FKI9J8YT5tyZ7yQZCgaZfJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For context, this is part of the broader __get_free_page() -> kmalloc()
transition Mike Rapoport is performing. I noticed it on the mailing
lists and found this site which wasn't covered.

Some background:

[1] https://lore.kernel.org/all/CA+55aFwp4iy4rtX2gE2WjBGFL=3DNxMVnoFeHqYa2j=
1dYOMMGqxg@mail.gmail.com/
[2] https://lore.kernel.org/linux-scsi/20260704-b4-scsi-v2-0-7d2d21a810de@k=
ernel.org/T/#t

I apologize for this messy reply. I thought I had added the context, but
I didn't.

Best regards,
Mahad Ibrahim

