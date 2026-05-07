Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C47BCD3427
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 08:31:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEE9B6B008A; Thu,  7 May 2026 04:31:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9F176B008C; Thu,  7 May 2026 04:31:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98D816B0092; Thu,  7 May 2026 04:31:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8190E6B008A
	for <linux-mm@kvack.org>; Thu,  7 May 2026 04:31:01 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0A6DF16045E
	for <linux-mm@kvack.org>; Thu,  7 May 2026 08:31:00 +0000 (UTC)
X-FDA: 84739953522.02.9803B4D
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf05.hostedemail.com (Postfix) with ESMTP id 10351100003
	for <linux-mm@kvack.org>; Thu,  7 May 2026 08:30:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TD28UqWQ;
	spf=pass (imf05.hostedemail.com: domain of sozdayvek@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=sozdayvek@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778142659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nQFLkhSM0KCrS/GGAO/Ew0CjOKjOQsQ8J0e+alSilP0=;
	b=x4YvOUb0s3W6XvtWkVruSUhNAGL064/loQF2j0zXgeFhnW3rEZ6AhZwsICadsQFcNuAOQn
	sH4DMKeQ1/heFHh+d/aXwqYbn3Wri0hRjx4c2CphCRSKd83axIjaSV5b9swuteQugsQRZc
	dBvryl6wcmcHLygplIGBGTu7paTRbcs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TD28UqWQ;
	spf=pass (imf05.hostedemail.com: domain of sozdayvek@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=sozdayvek@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778142659; a=rsa-sha256;
	cv=none;
	b=TySI27v3VByvFm3pm+126QgsrJbHqL78H3CYPPSdb0ynKFyl44FzHJYaGoGPkAV66lf/ol
	rXEh0cU5oPLjRU7ZRs1qdRG5ANHnv5yuab6XznKAyCxqvLXSSAmETkl1eSXZw0AANNhCC/
	VyqPzu0HmgXgGjEJ29etWxWpwIPe9UM=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-43d7b879691so20191f8f.1
        for <linux-mm@kvack.org>; Thu, 07 May 2026 01:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778142657; x=1778747457; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nQFLkhSM0KCrS/GGAO/Ew0CjOKjOQsQ8J0e+alSilP0=;
        b=TD28UqWQ/fHUeU3zanchVx5/BAnWa1IdL/lW9IpIJLvQAhWzGK5h3gf0rMEjCznXEy
         qJOrf9J26JJBiHo+KGby0YWJZlwScnE/olxK27YenIBHEchwSzgHyQE+2JpUloDdILGS
         8pCWmdIpeLxvEsCm8PnTQh3P8hiiIWfIyEq1DzUasXhT3zehK5MsKlSBUZwQxUAFkBWP
         PBN7CHej+m8+6HBreO+UpcW0+zOzwK/SbJUrtqTDW8UVZ5gC5qowGf0JlMeu586ygJH2
         45QaK8fQTtmJpf1JXZR7mCsDR+rzYZ7CaAWcFANVAKbLupoHSzCycEuWpgA5JmnKAjra
         0EDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778142657; x=1778747457;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nQFLkhSM0KCrS/GGAO/Ew0CjOKjOQsQ8J0e+alSilP0=;
        b=LQwP6eF9gzCXMP/IjBH2Q6yl/Oh2Tp3K3B+yQS0tvhr9Ckk7zqEcq+MbcH4FKZjhxu
         Q33DHMdyFWNuU37te2XHwcIIfBPzYhwBSIXDS47wFvj9sXsSTd18m9A9EWZiED/IOw4M
         CCYiiF9jb+8ynq6Nh/VsZ//NaTjMrSkEXkQfDcJYqgAeDDYORnNU0i4drzgNBhW0RKok
         qEN9EBPgH3p4euFYwL2t7p1tiuPxfgXEkDBil3T74/p67yhzw6gy7dRywYg5tKJgjchl
         AaSGfdGb2MZJrvQ6fObM9xk0t8xIsu7dCZwGkuuOE1dk62sdFxVytsh2mo4mQVA4GCxv
         /6qQ==
X-Forwarded-Encrypted: i=1; AFNElJ8fS/YL8KQiwiNNKBj3sASo1lXQGBHabalEzhC8tL+XtRlgtsgTX46Ay1ZTMSzYeUqvbvGpbKRhuw==@kvack.org
X-Gm-Message-State: AOJu0YyDymzRp2jGBW7sd1qlM/Z3KtjSwPn7jcAXQO3b7JRJXoGv4V4Y
	pSAN12KWYB2v0w45L6bk9EraYQvBNqvdHeen0FeNiXaVInUIVU0B78X0fqZtjaFdQBWwcA==
X-Gm-Gg: AeBDievmF7TnXBb9bUHJfeWLrLlvRp3LEeJ+na1kqoax2fpiUzLOyKHtB0lUQ7JLZHJ
	5Iri3GtewZFx9zsKMaPPG0hxt1OuLV28jAS8e5paX/LQ6WVtClQzlcjMIClxGWUV34WWIn6K7Q0
	U5kgo8hTI1g8UAYlZsVEnsjMZej8jFNYsIbcnFLaqdSJemKXniXtKSdOtf9LfPVG5lPtJ/vVUnq
	5NLrenl7Ebgct7hRG4JfVL6hBr5pjquiIERrENXicNy/BkJx6X8vyhwPPLXE2JTSRn4q5RlgYWQ
	N9gClFMGYKXHVkzyL0iQXFyG+XHPYYsNkDV1TuEAwnu8u1k7FpS0ALpN2skOBPmyxh6woa4lj5E
	wbtlC8HnmsGCe+tenWgh2TVa14+xv6X7Dr7CjxyWcAOL3iTo8v0pN2jgrRpo5UICsYAWvfqeO++
	vyxM/prZeqBuHaYGGLI4Bf2TOOohmaK4ra8+dcqwVJD+x2wUsSHFw=
X-Received: by 2002:a05:6000:455c:b0:43c:fdfe:bdda with SMTP id ffacd0b85a97d-4518bb742bemr2511449f8f.6.1778142656759;
        Thu, 07 May 2026 01:30:56 -0700 (PDT)
Received: from LAPTOP-9UC0RPH4.localdomain ([94.158.58.43])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45054b02802sm18769576f8f.17.2026.05.07.01.30.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 01:30:56 -0700 (PDT)
From: Stepan Ionichev <sozdayvek@gmail.com>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Stepan Ionichev <sozdayvek@gmail.com>
Subject: [PATCH] mm/gup: tolerate NULL unlocked in fixup_user_fault()
Date: Thu,  7 May 2026 13:30:50 +0500
Message-ID: <20260507083050.416-1-sozdayvek@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: a764fdo83y3swsm5tz1kd54x81tkuee1
X-Rspamd-Queue-Id: 10351100003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778142658-186695
X-HE-Meta: U2FsdGVkX1+D+dGrMOm86sLuAW+wOh/VrYw8eQzWxvEYbesN0zilILOyf7YHNry2P+eMnFxK890DtBfIx/gpPzp/6NCoY1yaSyQZVrzlth+zYlZwkjDuaamAnXDV+uhXy+h7UZv3DWhfA1/C8z9L9FvJJz+loDL4sygfsaJ2VUHKpnGlq785/LZ4MGDe+WPdiGmOyId8pfr+UGgKtH2lrGnyWKMbguvLe19UaE532fm+Jk0USq8EPQc1UYAYlLmr4wuJwRVEoRnA8Z1l9pci9dACOwsgCeXDFWyfwXTk6zot5INwga9XZTp06R6NOaxC5iybk1wA32q/ZIwB5vJpA0dSE529N3KpXoi+DT3yVijpNEMEu9+cuRI1CCUYeLhzG0F98nZZ6wOenYwkDObdjmOYsb2X8opm2bZ11ZoPC2srMwmR1vLyCdE9Vdse9EmnY+Iv4ajB6lsTjcq5IsQjpBb1FOFbcrGbM/3n0Nsi+BYserg4DwOGe2Qiz+jhpB8DONuMP6RrsUC7FqcASmjgaelT6Ok2XqZ9je7mONGhUIpVI1eI2Tnc5y5pYD5t0v3OGhzQwTyJN5hmiD4JwrKov+NrqmWAy+FSYdgL4aSO/ZJPBv37ammYY92uLK/oAx1j+zcnX+JAAHouJ03+oW6+SxJu13dGy4+SybvvYgoT+L2HVswdeu1TGh2pA1ZKxGW9ilMc2hizyG6zMVXVdbUGTLNoLZb5QHos1YZYv6uHePve3TeNjJRE+CqobZXJ68hoO1qaepcHmpSNPeZwlAHZWliX5wfMJWA90QZIXatUq0ksDIoUwZE3ZufqIDAxCwpNak/FWVYhFflG6BawLg9yOOCAzTP6rZxeXQJhhrvJ8feXhGZK0J6UfAC+9MWtxzKlTdjJxaR9HUE3WxPZlxxN2SMiuEj5lUUJv7t2SkEJ9N4Rh2BzDtheM42iqy2uNfu+u71QQrafYhv75trPXNT
 mZONiK1t
 yudtlQld8AyL1bhFQT9adenZ9OLjErUDaQ+fwHTxTQ/BvKmL450SulwHpCkHWPVph1yOa7w5P5U2KcEzZyjA3UgrITDc+aRd8OfS+Mk+Fo3xJFEyfjeoDZ2KlUOK0J51go3dFcChJ5HQ74BmBVO3wxCS+wBX4/kzQ6O8+mIfsa3qT7cD+KxiGHBTzj6321W5FJHrQ6QLgJ5iNJM4T62tf7/MXEkyVaiFdeGlfYkhOz27pCJUrUxXYjkXI9W6AzY8AyLDLYjDic6lEa6u7T30wQVxtSYQY2Ps7d/479g7XlfrP9YFRvc+FD0CUkKK7vT1Pwv1Lb0L7rqO5RNgTYrPO+WevJjDPuMcBUFTVHwCoSOUzj5j5YBY+4J40W/mYjVbOLZXXMZyjoFRf8wI/qWs6s4gO4h9AQ2LqOsCGgtDYJ23PANb3XrPeyK2NGUunpzppaP6wPbJ1OjB59fJCLSHX3zcWhhs7sYpzsgGMqeOSw5TCcazLC9tfoZAU/pQYkXYRk+dR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

fixup_user_fault() takes a "bool *unlocked" output parameter that
callers may set to NULL when they do not want the retry/unlock
machinery. The function honours that contract on the way in:

	if (unlocked)
		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;

so callers passing NULL never set FAULT_FLAG_ALLOW_RETRY. In return,
handle_mm_fault() is not expected to produce VM_FAULT_RETRY or
VM_FAULT_COMPLETED for them, which is why the dereferences of
unlocked further down used to be considered unreachable.

That invariant is implicit, not enforced. At least one caller in
arch/s390/pci/pci_mmio.c does pass NULL:

	fixup_user_fault(current->mm, mmio_addr, FAULT_FLAG_WRITE, NULL);

If a future change in handle_mm_fault() ever returned
VM_FAULT_COMPLETED or VM_FAULT_RETRY without ALLOW_RETRY having been
requested, the unconditional "*unlocked = true" stores would
NULL-deref and crash the kernel for this path.

smatch flags both stores:

  mm/gup.c:1597 fixup_user_fault() error: we previously assumed
    'unlocked' could be null (see line 1573)
  mm/gup.c:1612 fixup_user_fault() error: we previously assumed
    'unlocked' could be null (see line 1573)

Make the NULL handling consistent on both sides of the function:
guard the two stores with "if (unlocked)" so fixup_user_fault()
tolerates a NULL output pointer regardless of which fault outcome
handle_mm_fault() returns.

No functional change for callers that already pass a non-NULL
pointer.

Signed-off-by: Stepan Ionichev <sozdayvek@gmail.com>
---
 mm/gup.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index ad9ded396..1a8d7c7c8 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1594,7 +1594,8 @@ int fixup_user_fault(struct mm_struct *mm,
 		 * could tell the callers so they do not need to unlock.
 		 */
 		mmap_read_lock(mm);
-		*unlocked = true;
+		if (unlocked)
+			*unlocked = true;
 		return 0;
 	}
 
@@ -1608,7 +1609,8 @@ int fixup_user_fault(struct mm_struct *mm,
 
 	if (ret & VM_FAULT_RETRY) {
 		mmap_read_lock(mm);
-		*unlocked = true;
+		if (unlocked)
+			*unlocked = true;
 		fault_flags |= FAULT_FLAG_TRIED;
 		goto retry;
 	}
-- 
2.43.0


