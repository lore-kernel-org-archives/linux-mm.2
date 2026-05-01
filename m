Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8522BCD13DE
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 01:22:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D55BD6B008C; Thu, 30 Apr 2026 21:22:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2D5F6B0092; Thu, 30 Apr 2026 21:22:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6A676B0093; Thu, 30 Apr 2026 21:22:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B5C3C6B008C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 21:22:44 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 70891141194
	for <linux-mm@kvack.org>; Fri,  1 May 2026 01:19:39 +0000 (UTC)
X-FDA: 84717093678.20.1A90B8E
Received: from mail-dl1-f73.google.com (mail-dl1-f73.google.com [74.125.82.73])
	by imf06.hostedemail.com (Postfix) with ESMTP id ADBA6180011
	for <linux-mm@kvack.org>; Fri,  1 May 2026 01:19:37 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=e6Yn4pmV;
	spf=pass (imf06.hostedemail.com: domain of 3qP_zaQYKCM0y5tH4xz77z4x.v75416DG-553Etv3.7Az@flex--fmayle.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3qP_zaQYKCM0y5tH4xz77z4x.v75416DG-553Etv3.7Az@flex--fmayle.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777598377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JxBa4eZL8AzEIKHbrJYGdhnLoHOErJvUxGit6YEswu4=;
	b=8ibEroPSaDOyltIGwYpLLMgxFleaUpCRyuP/2vLbnHBa96fqHo2/NgmSxDs2sKpdOrPBeA
	lQdJsbnGmHV0s1C/Fh+TtDy9Dbl+OG7fR+dRtp8/9GcZl0oLl9yYDptmgjGw/4Zidfs9+F
	aF1hwejKQ6RhL73OYD70DbZoHrVg9bE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777598377; a=rsa-sha256;
	cv=none;
	b=Pca5aIzbruY/s46qYUz8x8pBV5fmoW4YKduE+qwYfnIwB+bA5d+gGHdEF/YgtCf9urrVlS
	lEP1rr5aJRVwFV5azVf/GGCvWcBK5uPP43T6Iek0jOtYShopH8y6iqI35+tn8+g62dkKWU
	lrKBh3Npt5HHlFMdbkydWM5T7d37NF4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=e6Yn4pmV;
	spf=pass (imf06.hostedemail.com: domain of 3qP_zaQYKCM0y5tH4xz77z4x.v75416DG-553Etv3.7Az@flex--fmayle.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3qP_zaQYKCM0y5tH4xz77z4x.v75416DG-553Etv3.7Az@flex--fmayle.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dl1-f73.google.com with SMTP id a92af1059eb24-12c8de02a4dso8709440c88.1
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 18:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777598376; x=1778203176; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JxBa4eZL8AzEIKHbrJYGdhnLoHOErJvUxGit6YEswu4=;
        b=e6Yn4pmVAyX4Ef6isnH/jZQ+Er7Wc02oQILRdstHeClS3pvtNEmLY+JizOYNQH0tZR
         kz29h7eNKDoYzTboyvv3qBwccNWMPZD1V7lX0EjNbS4EfziMhjLH+2/Es8MJx/sqmdRL
         Qa1SkgBOp9NIpQUm7mShwZ4h0WdKCSQms1Om4sGdafRW3MSRJsW7ADRUnRlZzKJtHe8G
         56L11wBSw9PvBVLhTuW3QCiF1k+62MHW1nG+zC8eOxlABCxI18jVIrqqFmUARJxWSxCP
         i127XUWiQs24N2UssAUHRbmM75o5KYlRG7eFNkpi6VV+s9W2ENqU8Zv5cFvwYwKRqRSs
         BKXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777598376; x=1778203176;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JxBa4eZL8AzEIKHbrJYGdhnLoHOErJvUxGit6YEswu4=;
        b=LBNzFcSHJqbaxI+w0gvU6XrJ/JgOg/R96kE/CQdtZPkMoUP7KYE1ZLIffNZK4e2n1C
         HEI9+jIV6BLrsaAk7SNQvXwerCnBd7AaZMqjOEWmh8+HN6PaM4Y9z2UEu47i4ppmIeeo
         DDoxUyXIzPCf1CIgxUWZ+k3smAUgzSmj7jDcv2UleUJHIt5QinXfEYkJkvU1m1DHcSwa
         rEgXKoGLcvsrra4M++b8WRojTekF3bR0x9H04ixcdg9uzVVzet24oDf5mZvjLMSeqcvz
         noUyUNJTjA1xi7LHYg0qDI1re/m0Y1O02wRgKjQuUoScdYVLMnQWkhSUXiUo8IErvdv/
         piFw==
X-Forwarded-Encrypted: i=1; AFNElJ+OAdE1zfH5WCU8l3zdlKUgnmWhYdPCcdP0LyTMTQLS/JClmCeT4Q/mHBKyXkwSZqqVkKaOo2RGuA==@kvack.org
X-Gm-Message-State: AOJu0Yws2BImEXs6mXfwSI3tmZ1enBzJIvepmEzSgsaQo8yMPR/w8mf7
	yiN57EWyEIlkvnKlcnMLjm4Po3/TmBfvvRPl9bkE2WRLUhXYo0Nq+qq9m8dZhAIudPAZheEZ4Xh
	KjSIU8A==
X-Received: from dlbqs4.prod.google.com ([2002:a05:7023:d04:b0:12c:8bfc:84e3])
 (user=fmayle job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:2510:b0:11b:f056:a19b
 with SMTP id a92af1059eb24-12deac72761mr3014031c88.18.1777598376170; Thu, 30
 Apr 2026 18:19:36 -0700 (PDT)
Date: Thu, 30 Apr 2026 18:19:07 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260501011908.3630802-1-fmayle@google.com>
Subject: [PATCH 1/1] mm/readahead: simplify page_cache_ra_unbounded loop
 counter reset
From: Frederick Mayle <fmayle@google.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: android-mm@google.com, kernel-team@android.com, 
	Frederick Mayle <fmayle@google.com>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: ADBA6180011
X-Stat-Signature: jzno9tpe95dz9gr7juwa3dzwgne6xxmq
X-Rspam-User: 
X-HE-Tag: 1777598377-650741
X-HE-Meta: U2FsdGVkX19wgh285tL0gxxHnOq7QCGvIDVINjpBzSQRFpk2gzEwz33JJXDZnELsdEQeY+tVwQeKZHbDdvD0rZmOYOsSyM36HiSlCdUUARoAtGxDQuGPWxClywtVKjdWg/anEALvYyuw1hJbS0LdA+nugiyJGxZWauxbCqBQO/0RzM7cZFcsCuwc9LUTy3AjpFRmXQ/GMkghGha9Rb4IBILeW5L8mjfSxpldwLt7PzVbbmsrV93i2vm9u/3sV74ZdACPnd6DtabKG49JG9exZT2//o4rq7f/0WBwvu6iNS1jRVxtj8NR6Zmlhq8/KkAbXwCTsI4Kghcl3DY97fn/S+MM+gzcXCf/KrpWepIHf+YqBtzQFJvpEjYq4V56MSSDes4FAdXFuHZVcqmnJEuanu9//9z4PqnqBxwfG4LxztakilS8+E8KUwSfxgrTRKYehaw2FlsNPGFzf0gSawBrklwRWYcqjdE4NA9k7BmM8srey18YCZ6UzF2BlTt9TVc2VIKsnPOf6PiYWliv36Zpr79KrGhzJHnz8axjNaDkqfCCeQ4n6miDAury3varw48raijOjTZ7RHV2GfOX0tvJhCYVPCJ6vKwykC0PiPl7/6U+EYum3VCxwI0KXRVytTUdCcEcJurArqPFvad/xt5jh+SFIqangdzS3puv6fN3E1R0OTpYM31ljUMoMPPv+o5/aaSuqEj8p0D0LBAEfXsypPKpFds5LyfwY1uE4gmxeesEzpP+p3v9kGTcpS+X4wXCPHCRSCiG20VifgNyAGYDNEGLJkI43LZTAr0ryvdK6n9A67TMcCU2VbBnMFNUTHJnh6WECDkD0X5Cu9/PqaUz7YecFHvtu3WIkRoYPniBhg+KsPbvvjvaDz91DyTn2T57dpyI7awiTcwtZ80+KrFv8a2wce/lS/BjJuZNsBGCUu8wtVw8CUkOZ+MIkF38C+ooigZ2Dgr+xK/FZiFOKKb
 0q6EUUqe
 byv/5+wY0jhOQJQCbeCaEa0/ecbnXRyyWvKCAa+ZTk3ZwmYDBASa1VWGo2p4PbFXUjdPBYqmjehu4i9BInpftNBC2Jj4+Q/PO7r/MYLjbHAwaGZ3XoqulJepHc9W7k5Gn5sFp7/IWPUeD7UjAx+/M7iQ6yCjtN0ECAuqAhCwfGjIJu+xRKg59HRf86RCxEuys/Qt8jjO1lXEEUwerk11JKL1naYrLvgK1SJQvFMc0MLaFj+qjynsO4hqf79KPbZQnQ54RaZzTLYlWeaF/53kXPTV90eMKWB12UAu369mbsQmZgCJ4QYwzCDoPAJ7gRj/qCActLhjO60HyoAeQnbdUu43eLBOj/fLZ+4kAgDBYgzDVHy6TkR6m9aFeuCKpna9PD8ktBPZivuKPK8XGI7A1tyEkkocqMcyL9NRBTD0EFk18jPT3HEzlETqdHvNoUfQPNLTNkYw6wS9dcrxMm1v59OfdKlw+nb8Gg67EnfhuJHvwICdpyyOd+joJ2Ts0Hwzo0udJM55DOfrEN5Rfjyr5eC77f9ZHRzslDYKaYrvITjINvmub558yGl572Q8sGWzWidaC4adydPXTkbwkj9SEaG4ZjMRbB859i9DqBxeoAE5czX+dqHn02eidT4afHn5n2ebXQrHLIqWN6dpkHIYlJVnmnBuYqHXDl29facT0tXNSV/0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Minor cleanup, no behavior change intended.

`read_pages` ensures that `ractl->_nr_pages` is zero before it returns,
so the `ractl->_nr_pages` term in these expressions contributes nothing.
This seems to have been true since the statements were introduced in
commit f615bd5c4725f ("mm/readahead: Handle ractl nr_pages being
modified").

The new expression has an intuitive explanation. When filesystems
perform readahead, they increment `ractl->_index` by the number of pages
processed, so, after `read_pages` returns, `ractl->_index` points to the
first page after those already processed. `index` points to the first
page considered in the loop. So, `ractl->_index - index` is the number
of pages processed by the loop so far.

Signed-off-by: Frederick Mayle <fmayle@google.com>
---
 mm/readahead.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index 7b05082c89ea..b44f13ce5935 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -270,7 +270,7 @@ void page_cache_ra_unbounded(struct readahead_control *ractl,
 			 */
 			read_pages(ractl);
 			ractl->_index += min_nrpages;
-			i = ractl->_index + ractl->_nr_pages - index;
+			i = ractl->_index - index;
 			continue;
 		}
 
@@ -286,7 +286,7 @@ void page_cache_ra_unbounded(struct readahead_control *ractl,
 				break;
 			read_pages(ractl);
 			ractl->_index += min_nrpages;
-			i = ractl->_index + ractl->_nr_pages - index;
+			i = ractl->_index - index;
 			continue;
 		}
 		if (i == mark)

base-commit: 88ca94c8849696985b1b70ebec4b01c4b58cafdd
-- 
2.54.0.545.g6539524ca2-goog


