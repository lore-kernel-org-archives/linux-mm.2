Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27575F4BB80
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 19:26:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52DA66B0005; Tue, 24 Feb 2026 14:26:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DB956B0089; Tue, 24 Feb 2026 14:26:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BCAE6B008A; Tue, 24 Feb 2026 14:26:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 27BD46B0005
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 14:26:25 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B07191B62FC
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 19:26:24 +0000 (UTC)
X-FDA: 84480331488.07.5F4CC2C
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id EBE6DA000D
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 19:26:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T47nelFX;
	spf=pass (imf15.hostedemail.com: domain of ethantidmore06@gmail.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=ethantidmore06@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771961183; a=rsa-sha256;
	cv=none;
	b=2WqNBFGnx2cUZjOT9wJzi4HmH9IItUbPMxN5krmjgfzGbnv9FzT2jvGIAJtA6XgBCgzmjI
	ONXFc1kS9HoFsi5tThQhhhZyaKy4ZpBTMk26KUksoWK1eF2W7E19G60/RtT+PFaRQfXBnA
	RsW5VxwCK0jpJFBPRjFb8ym6CSxEOrQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T47nelFX;
	spf=pass (imf15.hostedemail.com: domain of ethantidmore06@gmail.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=ethantidmore06@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771961183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=V0Y/rmePv3yFMUN4F3W1Ur6uXEINhlgG2tZ1RiTQJ9o=;
	b=69V2U1JaV+ZJWX5O0zDZi73+MVmsDd/YixspwSjao8nx8DnvesjJlJXGlhAu+Jx7zDpLI0
	rFckeEQZRnCNXmox39HtIjQTlxZKI39tdXTQKkYJrUMVWQFzn44hDYU9GpTplAfalsAcKJ
	qllj0psBXcBx89QtCY+edg00LGlkIT4=
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-79628fb5c05so46165687b3.2
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:26:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771961182; x=1772565982; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=V0Y/rmePv3yFMUN4F3W1Ur6uXEINhlgG2tZ1RiTQJ9o=;
        b=T47nelFXfLaw4qN8ryMEYEGKufu713t6jqGRr1MxI8F4Ju9EW6gVtvcfK8yhtJdddt
         5ym6Y9Ogz2bBlarMQQWHpLXI+dOmEtcB89sVIcCOE2Ao667MRTBe6hU7b/Cgn8uDkOig
         qE5AF+f12Yyl7u+DqKESRZl9x4rNsSk33P+7vp/acblXv/ihDWG3NOLfunFgg7kTzXBd
         x84/SJJSejWAYC87odLNcV1LCvBuNriNKmTvzdil8ih4A/UCdQmD3A/tpLjrKelTsufa
         fqgtD9n4iEGUPGYXsvp8/uMA2q302Ttwa0RNDPyPbPaZFomKCBsE6prOv3tjbZbcbi7a
         6a9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771961182; x=1772565982;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V0Y/rmePv3yFMUN4F3W1Ur6uXEINhlgG2tZ1RiTQJ9o=;
        b=Y/t3XEqqg+DkbGTEZP7jR7Tx/bOBZRHdcDp7+khvOM4L6tYnSpU02LyqonbXk24uNj
         Y1Fi7ejqU1s8LIcNvHZSbm2ywm232tgO6aTlMqN0caALBjhDEKsfnn/xWIRHZpoogdBy
         Ub59gGck52nalCgVKO0WM7SCtGhGi3ua358Kp53U1qQmJ3isE/drfqtvfK2yU1cW2Ysf
         RGzv+Lk4NeKSoiuaWGFW7X23vKSphID9ewqwoKBk9hcATubMA0ytln7vOev9h4E17L99
         SlYCRzTnlu96cj0IdvcAB2RV5lBy7qA32TRznB4ptoD+4MIY9VRUTkosFWjXvMEs8H38
         kcIQ==
X-Forwarded-Encrypted: i=1; AJvYcCXy/YeWtIjHxxmadArNQP9eIXe2+nnW5V7PJFSKLvhTl40KGdwj07p1gXHaFrsn2bo2vWazyfdRAg==@kvack.org
X-Gm-Message-State: AOJu0YxxwF/oNPy6FHVizxBjsoEhmPGC4dTLFQhPtMvp0fdLsw5MocBz
	IixdqmEJKSZWl3TdOigT40677wEW2EnzrYsLRomth607UN8zHIdKxAx0
X-Gm-Gg: ATEYQzwcwnKSSWTtqNA0TQixWNORdRxxhVf8pulZ2g1C9zAKf1YkQIKhrXpGq906dHu
	BGVh11yVGDPx7dcRHkvXR0BQowFs8crgHdYl+7cwG6RkCDOL6VwOFXt9E6JyVgLObnHpdJQOcXc
	vToBZDRsexQdVzKp2njVxEN9av6aQvjJz3Isc3XaqyVOB/GD7F1MzoTpzcckrxCwEtt+BZvrr/N
	3QzGhRjo+BVJ5WCnoxTLvzqwl35xNUrvS0OWBCuIFvaT0/M255hHeol8srkWithBHaKIWTQnY4B
	SIeXEnukDKYCrd95CKCCdhjtTUhe52zilMTqfoSI56QaBJdkzLmEypBI4CahAXdKH/PK/4bWNuH
	6/5LV11Gyy+YZR2HVQXJjn+Y+FGP8w71Ek428latpaXLvScObtjHJuDr7qQXQWniQILjalqGkVf
	4lQDjUos3kvPQ+TTaywBSHM4nj47MSarNYMj4V6wdpRG/HrGmPQskmCKGYt3kqWzaknPBpRXJMH
	2JwCsbvNF2RK7onbC6VF5rh
X-Received: by 2002:a05:690c:2010:b0:796:5b5e:f4fd with SMTP id 00721157ae682-79828f4d958mr98404927b3.29.1771961181820;
        Tue, 24 Feb 2026 11:26:21 -0800 (PST)
Received: from tux ([2601:7c0:c37c:4c00::5c0b])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7985e72cfb4sm5949577b3.42.2026.02.24.11.26.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 11:26:21 -0800 (PST)
From: Ethan Tidmore <ethantidmore06@gmail.com>
To: Christian Brauner <brauner@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ethan Tidmore <ethantidmore06@gmail.com>
Subject: [PATCH] shmem: Replace IS_ERR() with IS_ERR_OR_NULL
Date: Tue, 24 Feb 2026 13:25:59 -0600
Message-ID: <20260224192559.2429005-1-ethantidmore06@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EBE6DA000D
X-Stat-Signature: 4xuq1qi8dn1sgrkk86w3sw1k5zw4m68e
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771961182-115452
X-HE-Meta: U2FsdGVkX1+dMgw5+6UNJsYzKp+irYjFfk4IyfGZfOdboux2KqGEa/Xi2ivrn1umLy79jlj2qavaeqXqrCpAnz+FffLk3bEKIk//Ve6sueZVWShgTkHJedmXoFeiDATcYme+39nbzbRUD8i55v8dlnA1p61cHPFSzRClBZRcNBO86w56YpyaGyfAmc+GCAweR+6WtzdaQzyCzPV2qs0obf0VNSBN86wU+W7jh0xgZU5jRTiAz5U/uY4az/ZstDe1ECH02WdjEoLnjEDTCNjpo2tHGSxNpgbbNn8pfvJ+aliRPP3oxCcNQUjTBB98M3R6W4AYzqv8cq2mQGBeFKGOCfz8Rpz7FXuYDcc7nXMvNP6nbeD2LJamXkAr0vHsFocCo8HemCMrDzNq0pHr/Ne0FadqjGZomPJ3XHzntxxQiG2e1IihDTnrf1HFBFJ2+jmKm30TwnLBITah52ZiaQSmALL/QbOU0YqQE4RHF24J8pS4QmJG89GK2REjiAiYphVCAk0RGa8iESj8lBIkA6072Oth/Y9YdJxaPGfCYsK6W5SUwBj2MzJHhWQ5XuCWPGHE1ssiMrY9BT/6jfDEIFhswoxEbtzDPk4axHgo3QR/kQmS7ciyO4Ji0FZ9uMPs7bbHcDApCa0fpFgKVmLir3ODeedWF7wg1Aa9n8P5VUTiWw2MXNMDIhgskihUaq5TxhBCG81iCoo3PJBB3J/0sEZ1WpV7hzAwKvtSv/o2e7Va8X0RQjswiS9zKhqwibSyLBI/820Lp3R829qQj/ZsNdtB8qh01TPT8uCgv1Dxm9oVpmZSpk6rZxQXlkCkS+oNEyrO9qrXdYaoGRm0yVP8AVV+K9n6GBmi2DKX52Zb0+iV90jHDROXt3SvNBfrZS0L3C7a/rro1kvWAcbqnIPS5iQyoxew5Sky8KcMjGIL4m5i0XOtLvDAPI1XHyFaFkuie9n593WUq2y3x/rrI79DymY
 fFL9CE6i
 c7w+q/MOXkENyZgL826+TBS0Pmj2Q6wMu+x+LO2BNZIiHaz9XbI/ONkfpP3KOM0S6RcorlLt+Ff+t+ZUL7dbup+Hu37vi7GhVadVkv5xOdeLZrdLq/tm7EzAX9aZq4sTMOKMKRohBKV/gQyx+hv4QWEPvhXDJLp0E8EqnaSqemUybWpG58i9jFr7l8efgMJ6FVK6P3Y84FUH+KacmdwVEmcXraMixej6QsaRPGTsstD2hFy171o+QG2iJMojlc10WHFXAZEwhN8aU/slt4PYRCjbKRty627SZ2+kmaMZP8upZnXZWV59mVcSlnQqeTwGxbPXbgWDRBwv4y+onxWHRHt1B61z7cHX9RB8PlGxWRPJXYNp0bI5EXJ0aOUZShuJfVjpQ9KItkLlmtd9q6Q3pk4guO/J8j7QvDa+5g/tvTfmWyKXMK/iKv6ITM+LvjwJq1BnWwaVYh6ypE3wYVD+kRvXQJw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The CLASS(simple_xattr) macro can return an error pointer or null. The
variable new_xattr is only checked for error pointer.

Add check for null.

Detected by Smatch:
mm/shmem.c:4284 shmem_initxattrs() warn:
'new_xattr' can also be NULL

Fixes: 200a524407b8d ("shmem: adapt to rhashtable-based simple_xattrs with lazy allocation")
Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
---
 mm/shmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 805402e8c841..c97e5ff34d03 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -4277,7 +4277,7 @@ static int shmem_initxattrs(struct inode *inode,
 
 	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
 		CLASS(simple_xattr, new_xattr)(xattr->value, xattr->value_len);
-		if (IS_ERR(new_xattr))
+		if (IS_ERR_OR_NULL(new_xattr))
 			break;
 
 		len = strlen(xattr->name) + 1;
-- 
2.53.0


