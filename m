Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 304ACCD3439
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 18:20:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7296B6B008C; Wed,  6 May 2026 14:20:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 702016B0092; Wed,  6 May 2026 14:20:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F0376B0093; Wed,  6 May 2026 14:20:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3E7966B008C
	for <linux-mm@kvack.org>; Wed,  6 May 2026 14:20:56 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CBD7D8723C
	for <linux-mm@kvack.org>; Wed,  6 May 2026 18:20:55 +0000 (UTC)
X-FDA: 84737811270.05.1BE7D8D
Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	by imf02.hostedemail.com (Postfix) with ESMTP id DB0B28000E
	for <linux-mm@kvack.org>; Wed,  6 May 2026 18:20:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jUILUSoc;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778091653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AJmba2SxX4nhPogxtHtVcmYAhy7NbrUuv2ce99+duXI=;
	b=uV5KYJbNiEMBjiOulePBPqqaFSGWW61d2Ln4PpvZ1iqiK/7Is/fWGJQWjSvmk+MFeeNSg8
	Bi+K22nymPA9UyCCqCYlrpweJhB2w0kDYhhnEjNK/oDRhb30710MuNhpYqMkvtv1q/CAQs
	/bP4qsdtwxHapH2vHYs8WlCMDfJD4Co=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778091653; a=rsa-sha256;
	cv=none;
	b=t+AIgy8Vuzs848iukP9zRyP8ZqrZ9gELeLL8VZvQJOyRIlxNA/CKdgco/54viyEJ4jj0Mg
	YRuZ8RT5QLUMjKriAvLqzKWOphk8FohkPQQo9GoB1SCx3iSmzITOE4ZpYWme9hg+J57zZN
	pM80Yuk/LWKS6uCnUW1/cBrH7IgMZM0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jUILUSoc;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-65c2cd216c9so5745397d50.3
        for <linux-mm@kvack.org>; Wed, 06 May 2026 11:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1778091653; x=1778696453; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AJmba2SxX4nhPogxtHtVcmYAhy7NbrUuv2ce99+duXI=;
        b=jUILUSocmA54YU0KJWSxY1Su2dCSfuxHTG4ly88bFx4Umd8sWe+H22sAf24JOxLjSv
         JBx/yIJhiVzKXUtuViLFc828/piUFPwJ+b44y8HHBtvYcbxxT0pSGM79i8Piw1L4iWQO
         6ITUqy+ACp8eg/3hJzo9ha1SnhneUQz34b1m4vInwcib8BQstZhRfw/zGIDQxYXGZhOv
         5Dbufe5O1dC+zY8kqOSbwvDE3tBqcRuV1/Lhy+kJKRiEnDdlFpV7TJiDwSlQRMZ+k2kW
         sohfRAK7p/vuBKIQNsdSUa9Cghpu87b10WHBtm1GNhVxxpADbTp5otnd0aYLlNmmghpn
         dDVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778091653; x=1778696453;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=AJmba2SxX4nhPogxtHtVcmYAhy7NbrUuv2ce99+duXI=;
        b=Ca2rGxu566tuLIQ3Cw/b7YCyO2PTGtJjD+/vKdcZWKJwny1cRpg6jfi8MdqQta5x4a
         k5kOQfEnbIKQQj1KvMmESLAVmB9va/tdiQLlFL/d95mSdbyIz4kuZEuGJSU5bXNYgY5T
         kJ0V65sxREYBkhn9j79/nqicNVSnINthP9FhFrd5aFYPH555Y5pYTm0B8uzRO+3D61sp
         SO6NmDH8ao8jAJmp5io74YPEOgTuo3Fuw9/zvzOhrrVjgn8YpL8GkDtINvd2GnX+lBIC
         +WfMPmkLZgdW4QmzJzWOi/tRkI8BtCorER8u2Jqs7uneq3ffkvOKtW+rg8P0YnlK/T7w
         j4wg==
X-Forwarded-Encrypted: i=1; AFNElJ+yB7TmzCI37+gloakZ5RmYx3E9xVxhtcuRf9BB6A7adqDJu/mmt2uSk8TBw9ogDSibSQLPAxBmNg==@kvack.org
X-Gm-Message-State: AOJu0Yx4Ocz2ecQAV8WOafYNxKZIseeOLA8/mRfYFu8lzm9V/BUekCgm
	kBVB8YDtKTY+fu5sfarB67eyP4B4QVwzFcI7IgAFTgEqs9K1PNIHRSsNwViL7yC8PfY=
X-Gm-Gg: AeBDievAOd3vM12MlZH/bj/1HKIRQ/QjFgHqJR+mp/m4LqyJgP7UyKtJmtEPp6/td/Q
	88Epglavp4cZL0qQv5WFRo2ysT6tkPfGy9La9dzbVPL4zeVjXrYYzp31MDRuarZrJaklJbHS+TR
	6JzFaHZrLk4Ppyo9MjCosHgk2djWAFbt7ZAwoMxCGQlIKNB/AAw2gkjq69JbSe046avG9YWDFHC
	y4yuLLECg1fZnq1d7lLsZlRFpEinwGhwH98PYtmbIhZ6X1D5YdfXWgf0YXUhriMAiK0fsjrH5a3
	IdSwhZLbD2yxfHgVhSalRWVbyBHG/4R7rrsgo971n09xYfcN0S5LNu0ot24DF7/yZH/sh31UNyR
	s0RiF6y4gQeWRtRo7wLOmEzQShqKNCGevCrzu0WU9zeQh9hB5KilNctFMTcxu5+v/H59Nn4hccW
	w8zh0BQ+ITSXs6ts9y8vq9mJ+LWmKXAZ9rinzH5LqlV0/BRRzSJmUXjdEuU43G6jE29c3OEju8G
	9pwaPBPKKJwWuftVeg7TfMg7WOVkFqb84BlvbDyfdM7ioYCgfSX9Ucdse4n
X-Received: by 2002:a53:df50:0:b0:65c:1a0f:d8b8 with SMTP id 956f58d0204a3-65c79905398mr3711532d50.22.1778091652897;
        Wed, 06 May 2026 11:20:52 -0700 (PDT)
Received: from soleen.c.googlers.com.com (57.233.150.34.bc.googleusercontent.com. [34.150.233.57])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-65c7af9f8e7sm1389917d50.13.2026.05.06.11.20.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2026 11:20:52 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: rppt@kernel.org,
	sourabhjain@linux.ibm.com,
	jbouron@amazon.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	bhe@redhat.com,
	linux-kernel@vger.kernel.org,
	dan.carpenter@linaro.org,
	pasha.tatashin@soleen.com,
	rafael.j.wysocki@intel.com,
	piliu@redhat.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	graf@amazon.com,
	changyuanl@google.com,
	mario.limonciello@amd.com
Subject: [PATCH v2 2/3] liveupdate: skip serialization for context-preserving kexec
Date: Wed,  6 May 2026 14:20:42 -0400
Message-ID: <20260506182039.2623553-7-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
In-Reply-To: <20260506182039.2623553-5-pasha.tatashin@soleen.com>
References: <20260506182039.2623553-5-pasha.tatashin@soleen.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1114; i=pasha.tatashin@soleen.com;
 h=from:subject; bh=TWl94CwLxW3IjwCRKLhFCgMgquV90wVhjyKe40N294Y=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBp+4Z69J88+nkglNXrvKB3IepDP93CUFYvFWwGF
 oCjzLkChRuJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCafuGegAKCRC7dyhM23N6
 3tuSEACovUz5sKdV9Ff958EgDEwTN/HgyvwgLP2h9YFNQzKmSyfT6D6+Dsn4VxJ2zZG22Hck4D4
 euQS3vMKEpLfFbb7npsFzjo+/B/f9mxqaBYNKp++N6PKuWdM6P9Jlh55I/EN5zcemF/9+e2vXyz
 XJUf8EsXSMmuL6CsEySgMc6cF+8hZ9H3bUH+4vN6nWyyoe8PZD0d7Hhq9ROL+j89WDrs44hyYCr
 U2NpohG4vS39ANnTFjX+tYjoK3q3pfaCvFaBEEDpgwXFHIPzieU+GQX9P+sXYxqCkyA7G5xeBio
 MmwKpYDu3XABeRoHxXn5CZc/QwE7ztBVcotuLX7ipwqeOuVTcC+MO0uePdDW1SpfRr3wducrQR2
 3+4Vst0kcLRDAIkrYAFVBGFkyxIYfZ73GrvCIqWItcGTlXIJ1CbQD8YGXa2HK4lsJmnkFe4tC59
 CqZIzCPFJFe773dm0MkfzhXEnUtvGlHdNKrfGoaLH3uF8WPaR1nr/bM24yK+Ekr46sImu6zyd2v
 hLT45c8Ab97VfZjKtKhUZK/lQUXr9FI2xFV61Ykz7fKaSpIjlzesFHSnK+qEtnVWKMRcM8HgQj2
 cg3c2Ae4UaWjuuxenxg/bfIWJD11Z8YiLY7oP8i6yZSXp9rmgahzDuHhYHvX5YC4eFTO9f6kPJl QF/P2sjJQuYmDlg==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp; fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: DB0B28000E
X-Rspamd-Server: rspam04
X-Stat-Signature: 1sgqs9qr1e5ntg8yprwez4p66g9rj9ux
X-HE-Tag: 1778091653-629419
X-HE-Meta: U2FsdGVkX19BylfBa78QLkdgu/QPxgRuvsutliNA+uzVd+AuOcVxHFRrIpBZr9be1NSY+/rkWfYy4wgfCQMpHdXEV7oUotMoEHKu/MzzS+TZ3x46tYoGPyW8Q4h9xA7fWL1mVfj4yiLFFavnFUtchr3IwB7ixDPQkspiRDh0aQGrhqHLbDNxmrT+ccP/ErC5/w2gpiyBMVebwjUviWGaH8Oh3SUnBQUcl3/mOEfAAswfIAFZDlHQQGeDu/dq7+patNhg78jYfY77SP6wwARXDFalByQa/qsAFXUxL3/UPbERhFmb6DFgLuGnkW6iqtS1tNtPWSJTrLUd+znKrBCuvQoereMrqXKh6ANQCR/wBRFin5Gtu+vDuiUPmvYNzmi2M6mKfd6KnXXOyGgClGanBE5Dx5uJfzQpJCkx+Q8bBI4s0Bbs5chXwuwm7V8PZ4VaFQOH7txNMF9IwtGCsatXffJD+Cy6PJggVl0/lnXH3s5SzEL4ixRO5wY00PgkXv+NnV9kbSDXmPsoVRIB0HxwL5W0cVri2OsDiccjCxf3BYKT62U8u8aPIBjBJKbMUO42Rzlxn+gjn8ZZU8pa8x6ZBEzI/s+NiPasxN36nJF2FJ7JCWJG62ZZmb9CaVTdqSLBleVmu2gqfAMKHybJeDeS0vxh3Oz61sx7FbqROMTJhMGXvOw6CFqBrw1G8uMkam/xH9/SkS8R/zHItz07Wu1j9go5PZ3Jke3WGMmixIEcleM8VRjkMXuag63Oi8VENG1jbemzfF13DzccQvje22EERxBsDRsb1kTwPIsqttIIkXPLMVJfBAoX5oUFsZl8unVPyibNNBS5PyNzgfTzvlIiR/dI7MiOkwk2+eZZ/3662NxcxZZpGpZcRE9H+8P+OoYv0OvbEdMn0fE4MJC1yz5vU912p3QcIy8I7zkzErTn+29noOC2FRDBbDJYtpnCkxvTZ0JxTilA4r2QtRzC6h0
 ttXpwqEa
 TYx02p0VLIItIjO8sbb2u2ux6Md1PWzV475fhWFHLPRRNuC+HGq2AiWyDH0v2sQsgI3peHa14mH35IyqkZhK+4fuGIzN4S8RVHtYhj1oVyzFIMRbuV5ekD+UZfrZut7bjYQQJpBU7AK0+o346ZwjuITfsYczX1yZe7dfBmQHYPeNzsoxz4mXEBD2nVbJZ/Tcr38D/mDNykg5rwC/ALaJg51oK+eKplo7yWuZM5mHicPHTjCQzHEmF6uCZ/t7O1ZcyC/lgaQBMSCrNJQIsvd+m8bJnI1Y6JF40y/vPTN3IqGmXqs9lcgwwxNgLVKlOuUn5DU96HCrO1xsaXfOdKBQKepVBepZX6cSI5hhwnj9QxlN2xWotwsyQCjscIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A preserve_context kexec returns to the current kernel, which is
unrelated to live update where the state is passed to the next kernel.
Skip liveupdate_reboot() in this case to avoid serialization and prevent
sessions from being left in a frozen state upon return.

Fixes: db8bed8082dc ("kexec: call liveupdate_reboot() before kexec")
Reported-by: Oskar Gerlicz Kowalczuk <oskar@gerlicz.space>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/kexec_core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index a43d2da0fe3e..dc770b9a6d05 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -1146,9 +1146,11 @@ int kernel_kexec(void)
 		goto Unlock;
 	}
 
-	error = liveupdate_reboot();
-	if (error)
-		goto Unlock;
+	if (!kexec_image->preserve_context) {
+		error = liveupdate_reboot();
+		if (error)
+			goto Unlock;
+	}
 
 #ifdef CONFIG_KEXEC_JUMP
 	if (kexec_image->preserve_context) {
-- 
2.54.0.545.g6539524ca2-goog


