Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D70CACD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 00:13:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CB556B009E; Tue,  9 Jun 2026 20:13:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 654856B009F; Tue,  9 Jun 2026 20:13:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F5D66B00A0; Tue,  9 Jun 2026 20:13:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 409736B009E
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 20:13:16 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DAA2591A7A
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 00:13:15 +0000 (UTC)
X-FDA: 84862078350.28.D3A9EBE
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1B256100016
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 00:13:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tFAmtvCX;
	spf=pass (imf05.hostedemail.com: domain of 3GKwoag0KCGsJKQRbQNTKJYJcPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--abhishekbapat.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3GKwoag0KCGsJKQRbQNTKJYJcPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781050394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VHbnDTTx4SUTRx8/0+aZqHaMkKtJnoW/wRc2CebNntU=;
	b=HP24gV0PfdTJDrOBfrUUCG5iVcLlfZg/SQsGSxz7lJsi3V3rR5VS74RXE59GWGuR/7w4ti
	JjCFGkkE18O6NsUL3PR7il8EiVWr1n5dsMHARgFaU4Dk6JMdElL5hnnwrLxu6RYLRORSRP
	Fb7vml5vGm3ADbNMS7GSMqzM+gaBrsc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tFAmtvCX;
	spf=pass (imf05.hostedemail.com: domain of 3GKwoag0KCGsJKQRbQNTKJYJcPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--abhishekbapat.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3GKwoag0KCGsJKQRbQNTKJYJcPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781050394;
	b=Z2AqZlzRiOLFAveykydXq+/xnO/+kPWIOVF7q1G4mOqGhNFC71mTg4zXyUsOA0Ju/1HaHx
	tP4hsGlhSA3h1RUacR8GkFYmwq1ckUYg/yxnpCn5bqC44eUiICTctllaCzvnLCEfSQJrxE
	ZUY6aA0UOzRYUnxi1ukTyUU/SYPO9mE=
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-304b8d0ee63so8556297eec.0
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 17:13:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781050393; x=1781655193; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VHbnDTTx4SUTRx8/0+aZqHaMkKtJnoW/wRc2CebNntU=;
        b=tFAmtvCXGQ7V77pnRkD3OpL0VW83qd0u0hX77KDgcGLQH+9yH4fGoOnGf/8GMv2Z3s
         7jBKs1UrRDo2t3UZym2jSghUs0rgwLVesYLi6TRBzki4HfyzTbEzNybkQGjvykc+FQIs
         cWvj8qE3mtHSGGhWlP8zmkDbDG1sgdievO6aw2JC3Gotbasdv5udzKRhJxnhylwL74P4
         aeEDPSz5euI6qK6HZ8EtbXxTKY+SK4t6TmSKGilCbg9QGShrvrSp6a1DbX8phiYhQeGl
         gW4No4006MMmfW4FOU2YXhVTyqIeSMd5BD0jfD6hzD0wRg2XrRnK/pT00F7VAwvZlogl
         jM8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781050393; x=1781655193;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VHbnDTTx4SUTRx8/0+aZqHaMkKtJnoW/wRc2CebNntU=;
        b=EOkDT5t8m5BH4qw3P0qNqQBsL7GskLYszWoCm2DzYEl3+rmLTYsQvFtR05dL5z3H67
         ilEikxaNZoIjGPBAs64SqwpvQn8fbQJwKqA2FOO6v4ctKgz+Geb04HWclOw87rLF1HT4
         5zmkk5eGS4Bkuma2cNPaNglo6Zw+5dz6NtYMI+yzK9WbqiAIwhrI9tIQUjUJt3LdlJvO
         T7MQK8FZ+VFGWQIqngsxNn5wyg8ejT+IglPQzD5AiXBDQgIYaIzYKyvrQzXXVzNmIJ//
         uFZ2C9u8dQHXVGR2+25WOyd14lhkmyYIz5v6rjdJSOPJBtY2UpNahgK53c22WxoJn9AB
         6LZw==
X-Forwarded-Encrypted: i=1; AFNElJ90K2+GY4fkMwfcIJa/RltRH+LgJBjoU/Q2EXgLecSoxBxnnosjDMbHCdnaAjUApwfGKWI47hhC9A==@kvack.org
X-Gm-Message-State: AOJu0Yy/4wgDNRbUuSg1f6LLKOdWKOhAULtpYI3m3Dj5EXq4mSc0Bi7C
	KPXh3tjddpnJv3kbXbDX3bx0FxrgGwkejDtKtSp8TmGXNKAshx5ovu0hnOH9UDpEUEr3C1YML0Q
	vin7ZleHSs4OUbpQ5DsMS/T86QY6UyC1y4g==
X-Received: from dyba14.prod.google.com ([2002:a05:693c:63ce:b0:2f4:b34a:2550])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7301:9bc1:b0:2ff:c611:82c7 with SMTP id 5a478bee46e88-3077b0847camr13528502eec.12.1781050392582;
 Tue, 09 Jun 2026 17:13:12 -0700 (PDT)
Date: Wed, 10 Jun 2026 00:12:57 +0000
In-Reply-To: <cover.1781042698.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1781042698.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.54.0.1099.g489fc7bff1-goog
Message-ID: <7f3a4ddb3f132464f17716eaae657a6367d6dd05.1781042698.git.abhishekbapat@google.com>
Subject: [PATCH v4 4/6] alloc_tag: add accuracy based filtering to ioctl
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1B256100016
X-Stat-Signature: xmftu5jcuq6ipqtbqr81fapnr6pr4gja
X-Rspam-User: 
X-HE-Tag: 1781050393-10113
X-HE-Meta: U2FsdGVkX19e144ej7aWXWSabQV8v3a3JvGnNW97u7mkAyVmGYu4UxKF75vesGq1xrEL8eS2WEDLgwFPgabXQZ6vVoo5Kd+wockU6d+AUwl5Ne/gD8kvRBMHrmaD6vca+e4rPkZA3pv6yVxa7x7z+9XM/ZtSmGCq0x3pmRotsccd0GExOTTt6HVVDSWRFU/3yf8XpmthJxqyQWdv6WI8LvVZE7YO0d4JlscF7yQrX3rzdzZhISMr5ETX54OQzX5k2c87NljWL8GFaFoPPvx5PwNZN7dQWwijwwUIHX6s28OgbskRzs7WFhl+X3SnfdgxKv+kDcmsb1eqqH38eM831CUMuarqbTY9JPceLbUYLczLUN32rUp23hdR/Z3A/SoZiWwX232OgPLb/EdjI9xHCNV91Tgr2PeA8RkMq+SrUP0VlVH5tZMdIVC4TxDRranjg0pv1ukJIrBnYGUn+mU8C1aOkHKHQHcRKGbA8MvZ5w4bNcF23UBoEO8QyAmsZuY708ZegG94aEZ3FuYB7/cWc8ZwXktrzDN/38KLZlFRfYXoluDWRMLYMI+/mprgD7U/2LPTJ6/6FEY2l8YMazQdtHFkofZwmYL8hS48lqeT20AYyT8ZvcQTac3xkRnIfVQZKYPJOHzLtH5KLr2C5QKYuxrngL4l8pWi3IbVuidaKdn3bTHcQaFgnj3sRQLWjZqt9r8DwqwvQY5Dn2e/g/y8XAoLU7q9UuHRVAFkd9FD/sUmQQu4dr0L2akGS4VvjNq9Uym/Ssx70nrYAOce9uO99wPKltH7VpI6ymaDDEGkyeP7CleyXJXxDtC56paKTIBLqZ8V2IHJVhtA2gRqDkbpIhRK9Y1cua3o/+db75mKTwso2Afa/r/+ICkzmcSPoog/lb5KXSmSENxNwdkSR1+CsVH/YK2VQ4o92mijb/d/Reo6aRuzS/3bMyTYmw/PWXMmW+OZSBdV/ctY4E398En
 4E5CWWDD
 4HDlB6O10fVJvjnM+aHm59tRzf+KCLB2ALAhoENoZZWT3Zlt7BPaAFZDKrSw+bMUK3Sm5NgjVUVAu9EfbkZpWIRWcBVkUDVqnR+SNxRvPzJPsJzsZCb6uDVVta9Vo8E+Y5Jl+DdNniy4VAhNgLqOEUbrYa5PdhYlp951psLaJfuJ4CEokFjrUIIkko/PQSfJOzxPXqwy+bxIMHnE6yHVsp6YorZ8qwLM8nThMEwnGPMixQ4LAibOUoJQQYwAmyQxX+9DryIpRlNRLf+b4AIvwtu96JvRgGvqOoLpnNOcBWaXYRCnObtkXWrEIVG+riakhK9+h9Q2G2vwloP2E9/hxmc9psfkOZg2n5JE7lvrX4wOz/mtgpblx4fnfVMA/E/X+d3a0aC0JYsXRah+/G99f7dx+4weKZo4VgfbAH7d1J1+dFxvgEt6r5QTsAWgMAhe4ap7uehl8207pErXnT5ALFGOVfEY8xA2MSlvqBM2dlKNZAZM4/0skocgFUdvn5NGN/69CgRL9hvEWxOPB8xZwiSWgN824/gIIIH/fX8fw44Q289deaZftYBVtp9z5X7Z3hT0T4BlVj2GiVh7hS8bREHXbROLaZsB9LLRQwBqFh64/40QfwNJX7saqLGclwm/nYMwwdu40QX7uG6RrZdEVfdumPZP2g4BPqLx0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend the allocinfo filtering mechanism to allow users to filter tags
based on their accuracy.

Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
---
 include/uapi/linux/alloc_tag.h | 4 ++++
 lib/alloc_tag.c                | 8 ++++++++
 2 files changed, 12 insertions(+)

diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
index 7f5acbb44c14..6ea39c4869fe 100644
--- a/include/uapi/linux/alloc_tag.h
+++ b/include/uapi/linux/alloc_tag.h
@@ -26,6 +26,8 @@ struct allocinfo_tag {
 	char function[ALLOCINFO_STR_SIZE];
 	char filename[ALLOCINFO_STR_SIZE];
 	__u64 lineno;
+	/* filter criteria only; see allocinfo_counter.accurate for actual accuracy */
+	__u64 inaccurate;
 };
 
 /* The alignment ensures 32-bit compatible interfaces are not broken */
@@ -45,6 +47,7 @@ enum {
 	ALLOCINFO_FILTER_FUNCTION,
 	ALLOCINFO_FILTER_FILENAME,
 	ALLOCINFO_FILTER_LINENO,
+	ALLOCINFO_FILTER_INACCURATE,
 	ALLOCINFO_FILTER_MIN_SIZE,
 	ALLOCINFO_FILTER_MAX_SIZE,
 	__ALLOCINFO_FILTER_LAST = ALLOCINFO_FILTER_MAX_SIZE
@@ -54,6 +57,7 @@ enum {
 #define ALLOCINFO_FILTER_MASK_FUNCTION		(1 << ALLOCINFO_FILTER_FUNCTION)
 #define ALLOCINFO_FILTER_MASK_FILENAME		(1 << ALLOCINFO_FILTER_FILENAME)
 #define ALLOCINFO_FILTER_MASK_LINENO		(1 << ALLOCINFO_FILTER_LINENO)
+#define ALLOCINFO_FILTER_MASK_INACCURATE	(1 << ALLOCINFO_FILTER_INACCURATE)
 #define ALLOCINFO_FILTER_MASK_MIN_SIZE		(1 << ALLOCINFO_FILTER_MIN_SIZE)
 #define ALLOCINFO_FILTER_MASK_MAX_SIZE		(1 << ALLOCINFO_FILTER_MAX_SIZE)
 
diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index a936cf18611a..73fb3d0ab821 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -249,6 +249,8 @@ static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter,
 			   struct alloc_tag_counters *counters,
 			   bool *fetched_counters)
 {
+	bool inaccurate;
+
 	if (!filter || !filter->mask)
 		return true;
 
@@ -274,6 +276,12 @@ static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter,
 	    ct->lineno != filter->fields.lineno)
 		return false;
 
+	if (filter->mask & ALLOCINFO_FILTER_MASK_INACCURATE) {
+		inaccurate = !!(ct->flags & CODETAG_FLAG_INACCURATE);
+		if (inaccurate != !!(filter->fields.inaccurate))
+			return false;
+	}
+
 	if (filter->mask & (ALLOCINFO_FILTER_MASK_MIN_SIZE | ALLOCINFO_FILTER_MASK_MAX_SIZE)) {
 		if (!*fetched_counters) {
 			*counters = allocinfo_prefetch_counters(ct);
-- 
2.54.0.1099.g489fc7bff1-goog


