Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EFAB106ACD3
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 17:18:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52C3A6B0005; Thu, 12 Mar 2026 13:18:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 503A96B0088; Thu, 12 Mar 2026 13:18:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40F8C6B0089; Thu, 12 Mar 2026 13:18:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 31D316B0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 13:18:41 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C80C6B874A
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:18:40 +0000 (UTC)
X-FDA: 84538070400.12.ACEC990
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	by imf12.hostedemail.com (Postfix) with ESMTP id E08594000A
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:18:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fVrpL59N;
	spf=pass (imf12.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773335919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=a56UvS1s4hV4Kk+HM4JSgbIdUK40Wcvh+zEE5FW6h90=;
	b=PheVStUIas5fW+tvW4VyqoVv3Iow5zu6aNDHEgh3E5+BLS8+9TqmlpRzR87C7zCQReFaqm
	DFrxH0YxZWiS3IdjAcLxb6CsK+iX9Y/hmJjlT0a3yNmGAGuAPQEg0FfEmw0/xIoxkfy91z
	kweJJDUCsSXdHVRRdY+WzAHAfUUlr2k=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fVrpL59N;
	spf=pass (imf12.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773335919; a=rsa-sha256;
	cv=none;
	b=jS4ly0eZqZkx3mAHcBqpM1PBBt6d0Xxy5o/Sp01aY+jafyKxwBz/TBJyWoc/HNKIVdS3cr
	eWt8fapyVCF2wfRWXqqM4fgVTcG+IjhxalIYY+voDsR/Qnch+9df56/CsFMR4bwppJUUgB
	3efAUrQozRR9TM7WIT9j83YTCSIGFpk=
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-59e4a04f059so1413642e87.2
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 10:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773335917; x=1773940717; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=a56UvS1s4hV4Kk+HM4JSgbIdUK40Wcvh+zEE5FW6h90=;
        b=fVrpL59NCg5lrbeJqHJeAsiw+1qkGkwpidLTY7OhAfc2poVzOWyMnm1PTG69o9AnPy
         nQ10fzjR/RgmEN0vOdfALMGxdgWaGXRAupVRVb0thSFKhFeIfzJ1tmkolujcQv/0RNtr
         oume/Buoc4FEE0hn+SHOFWol/vkHbbaXseRNCyMcLPRnNpc0E0UW3EwbZgA1LM0dSaav
         iF/jlQPjZpFe6k0uI9XyxJYGP0Bt2vgsegGIFErrI8LFwivppKZoyKFPK0ptiiqE60WR
         12+WtTANi7xm2r2YFdska6uk4SWJnbTYfbeYrtO55QXG2P9+QmC1ujrupC0OjxMCqpyN
         lKOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773335917; x=1773940717;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a56UvS1s4hV4Kk+HM4JSgbIdUK40Wcvh+zEE5FW6h90=;
        b=WXNgu1zPEYqZhccpXKKB7CBiSFyBLGa1ZEt7UiHvR2Y/3fEFAn42sjL9wJ+RHliwzG
         M8Q1MoW4h5C6mDW9XL62KhZjDfs+nsd6kfzvpSq/LW0CmVAAxMbcC8h8rqJLOFvKUl4P
         WAoIPoyYhFblKJQIILwYAvW3e9orEAgbNXSm3ANrQUopA/2nlIxe/LzQUKeGDm3TjlIq
         nAjrw3Jza5sb7vMSm6J4+88aV611cdDRJLu8znC/YK+on80y42RW8JYt+hrBkRHqmV0t
         WwZ/srnt4TsHQl1rN4Lxfj4fdp5qnPvVtrhKvh+1kbykBCyExChrcBBK2ciBOG8ewJQb
         1QIg==
X-Forwarded-Encrypted: i=1; AJvYcCXEoUYOvhGzIf7DvKiHz7sva+yd21YDKoNS6NvyOzCLz6OFLLWorL56kCZzgPP2wrDua/K9pe98Jg==@kvack.org
X-Gm-Message-State: AOJu0YyA7G30PpTiK0bAiAGsYtwh2J1x6Ab+UT0ygIJyxVnhdWKAIPdR
	846GPYaBmnimdgooIIe5dsgKK/SwYmV2eNhcPoUxq/Hf6jmA+ecADJED
X-Gm-Gg: ATEYQzzzJhrqJsaMLB5A+8h9Q9849g80VdJD69Hbx1uyq0zEMVdHWw0vmFjafY7HL3y
	mZ5ZwjjiBjrvJ4/x4En6Al6MOsaD17vjP1+JOS4JK3VGhJQUDHJYWLncODMINbdVci82MLuo6B5
	/2S8ED5UlU+08nN/wlF+v1BHi2d+lqznL74YG0B4G9q3uBJAAxJ8bGoUeXlodHtGckmAxVRx+5F
	UszLGle/CW8mBKbALHfEuslZX5CXO1QjeK+RWCS9GFH4kAhvssdByOvfBd8iqQDZb2X5Kdxl5jF
	Ngs7pBbruCw+rEWP6XtIKsz8k3QIXuOMPk2vYcOHMUJ0SWm5Gro1nOHAZl37uhLajoJ9ZXaVwIC
	N3kbFAY7vpuKAE1sDPeseoUgSQxtknwJLiFq/nfXKXFnGH/Sj6C+kCtpy4n5fRpYamN/Ttoc9wD
	hmbrS2YU84IEvEygskhIm75ZggvD07Y2blTYKuh+iSJyp645VvJ1pUGGb2zmjslEKnkIyJJdQ=
X-Received: by 2002:ac2:53bb:0:b0:5a1:3e55:8990 with SMTP id 2adb3069b0e04-5a1626ffcadmr86207e87.15.1773335916871;
        Thu, 12 Mar 2026 10:18:36 -0700 (PDT)
Received: from ubuntu.. (static.159.107.27.37.clients.your-server.de. [37.27.107.159])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a156373888sm1036829e87.86.2026.03.12.10.18.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 10:18:35 -0700 (PDT)
From: Josh Law <hlcj1234567@gmail.com>
X-Google-Original-From: Josh Law <objecting@objecting.org>
To: Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>
Subject: [PATCH] lib/idr: fix memory leak in ida_alloc_range() error path
Date: Thu, 12 Mar 2026 17:18:34 +0000
Message-Id: <20260312171834.8837-1-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E08594000A
X-Stat-Signature: mumifhbaab6pzsgujfo8uw5p1tzzqznr
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773335918-138323
X-HE-Meta: U2FsdGVkX1+iqypt0eZzqSZ9s6teFMkvJmcrXO/tWRfhJFvqo7Jrrq5IoxJuYw8/C5474fq1rIUF/yiI8mZ1TZdUIjRpdQHe3yGTyoE0bFAolPf6AmIzxXR7nE/LOtk6+uyUIme3q5X3eqK5IBAnpIEfLTUQybOe2ewr1v401Y4lY6qtGnF84DTs/dPkowgZRKHmmA/gFSnIL4ueEjqB1VopfX+nh2yVJFWCqWhoWZlIirR+kPF/iw8sFcvNm0hpR0A+/BxAR0sf95oM5ayHldvFZo44E4ytIW7p6x3JIdN3bUGK8RxltdSTARMSocEidrstMSbrwvZ//gj4Ic4cyBlj9uVdBO1tWNXNQR5rstjpBywyobLvU2a1/fGTmp+I0GvmRr8quJ/MmPYsqIOhDcQB+gwLyKse7FW7egLG68Faelrvy+H+fGEQVSCfhEfy8qyqKrTK9jqJdmhwqqOvZmex50DiUs28Lp5X4zuQ2XnuPFELhH5n2fvyODYJ5Ts1hqTv/Ph34gTV+LXoZXLDTvnGVWH7nSdaefn9Cw/ICCx4JZV4gnHyPOEhLnqTkNVsCJd8NDSgFCUApPNoObSpI0pTfYbyIu8egILSnJb1YblQ/VV+TvRpst42ifeHSTbBH1UuPqlMsuF6JOjAwIIRqfo8bdbltHAMEnkgCj1S4DLGX5eCxKds+fSSrG5wZNMfxbTAgb2voE27yzzXNUQFaF2vfm0g9ss54eZaMcJkAqLxAk8OakKfHvFsE283IHDh/CmxtQSNh6RhkkLEkx5z2aHtsttBumLHdaj+1jgUl8msSTorXJoRJKBWJBzTx6XcJPMSuHRCrkLh3bJWHD+Nv8DgKffpFIfKZm0Tb0h2y8IZBpXIxW6vzbNcrgzTfNwlW66LtPJlPaRZm/qkc4KZzG+PqQ/WDJPm/pwof1xiSEo7V2RM3MhQN8tL3nv/UoOrt7DcI8CqaZ/VIH97bxM
 1c2jeK6r
 Lu6mHeLnRXQ7QYAGrvgxj9Da+waEjaPEZhsaLoMflvTs8bjamWRAJ/KprlpEGYG+oCqOi733IMzode/t/SzLmj2LMx+jsy5EnsZ+LYFU2mgo+vQkBKmqBaZfEmPmFz7Jc6KXEtXwC/yl5XzvFNps5boof5dRoK2m0GJcHlRb7faRNspGelSqpdEqSNsbgecL1ZK25LIGuXKKF5utPUfRvS55h6CUmGID/m/jMivpk0lIx5yIYBj5k4o2gl0OpaxuSUU+QpxwqVFSS1zJ0nW1ih6aSe0XMlj/QtitK+YqeAF6v/EFtqU3EXJIkQqEZvn+upra8Fvkw7IiExEx2Ii2WYw52ZMWCfHDSh7fQetX+nHGfrmkDcOF5ImwO5gaSFkuZYG6VPaKCL4Ao5EkdFGuR7iQlwYtxkd3ftNKm+y2cIhZwfdfiEY8zUPOSn3PTFA6dKzbQIH3LqPt/s4k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In ida_alloc_range(), if the XArray operation encounters an error
(e.g., -ENOSPC) during allocation, the function exits early via
return xas_error(&xas). However, if an intermediate `alloc` bitmap
was allocated via kzalloc() earlier in the function but the XArray
insertion failed, the error path returns without freeing `alloc`.

Reorder the error handling to ensure `alloc` is properly freed when
an XArray error occurs.

Signed-off-by: Josh Law <objecting@objecting.org>
---
 lib/idr.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index 07098eb4ddc3..2ad96befa17a 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -460,10 +460,12 @@ int ida_alloc_range(struct ida *ida, unsigned int min, unsigned int max,
 		bit = min % IDA_BITMAP_BITS;
 		goto retry;
 	}
-	if (bitmap != alloc)
+	if (xas_error(&xas)) {
 		kfree(alloc);
-	if (xas_error(&xas))
 		return xas_error(&xas);
+	}
+	if (bitmap != alloc)
+		kfree(alloc);
 	return xas.xa_index * IDA_BITMAP_BITS + bit;
 alloc:
 	xas_unlock_irqrestore(&xas, flags);
-- 
2.34.1


