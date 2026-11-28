Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93802606A338
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 06:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=YSZb+wzx
Received: by kanga.kvack.org (Postfix)
	id 03B666B05BD; Sat, 28 Nov 2026 01:52:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEAA56B05BE; Sat, 28 Nov 2026 01:52:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB24E6B05BF; Sat, 28 Nov 2026 01:52:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A697B6B05BD
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 01:52:20 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2087112042D
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 06:52:20 +0000 (UTC)
X-FDA: 85483608840.08.1938FBD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9D00E180005
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 06:52:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YSZb+wzx;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795848738;
	b=O+XdxUYcC1znDvhbUU53Y/6kEGPxqsEKmBvjwNjGsW/SEIfMpYu1k/mz8KwIyefWMWt+8Z
	VdK+gyLc1WsEEHRjArVV+DRx1LO3pACDo5VUOavHL9AXe0ugv2+ebeedCmrtfmxxkn74Yt
	kELmEVM7CgZziPlSSsUZdkLyKaW6zkA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795848738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=CuO5qfRmQn+iLmaatT72GZlf+KktppVECqOS7ecTo0c=;
	b=j5PWcG5paDsJa7aZTLCbmcyA1/+X3WrFS1SIDuFjpBQbBD1qdSZ5nfeDABYgLQZB3m8np5
	B6OeL/kJFRllLG1Zmqy1NVpAcSy9S4tke3BWq2dx9Ar3YfBNtjuAvSb4R36yhJ8Kvd+RM+
	/sH3ZZFbfjImC9favyGKmiKsyFs5YVk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YSZb+wzx;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D4F1609F7;
	Sat, 28 Nov 2026 06:52:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA97F1F00893;
	Sat, 28 Nov 2026 06:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795848737;
	bh=CuO5qfRmQn+iLmaatT72GZlf+KktppVECqOS7ecTo0c=;
	h=Date:To:Cc:From:In-Reply-To:References:Subject;
	b=YSZb+wzxpQpCCLRfEaBR5nrn3v/e5OS4Bbbjof9tPfumZizlTCx1xMyl/eQlI1RO7
	 kSPI4UiHCId2kFvu0aDxBekJ4vK3r9SIbRcDxPWJRPPUNatzAWmZYsDIHZ+h0Ynm+d
	 PQvt82Ijuvoioezk0Pa4TzzLcSIDBhwUZ1W6CVR0=
Date: Fri, 27 Nov 2026 22:52:17 -0800
To: Kurt Lin <lylin1023@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
 David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>,
 German Maglione <gmaglione@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
 Stefan Hajnoczi <stefanha@redhat.com>,
 Eugenio =?utf-8?q?P=C3=A9rez?= <eperezma@redhat.com>,
 Muhammad Usama Anjum <usama.anjum@arm.com>,
 Ryusuke Konishi <konishi.ryusuke@gmail.com>
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <1c93b263b19d4465899bb81efd62bcb3.9@linux-foundation.org>
In-Reply-To: <1c93b263b19d4465899bb81efd62bcb3.1@linux-foundation.org>
References: <1c93b263b19d4465899bb81efd62bcb3.1@linux-foundation.org>
Subject: [PATCH 9/9] selftests/mm/memory-failure: accept EIO from close after poisoning dirty data
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9D00E180005
X-Stat-Signature: rshieucmygryydz4fdhhsyzab6egzoky
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PP_MIME_FAKE_ASCII_TEXT,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795848738-422680
X-HE-Meta: U2FsdGVkX18XALFA2WmOvqob7OfSPSadL8LFJmiHQf27B2xFieOohwervbuWdyXyO/awJ8Dr1XL1aPDeVRAlZryY7usFedld94VcEoXSk/DpUq11W4WRRRRZWAtYR8HBOZxgeoBvWrbeXDO9s/BZP819v7SAIPLEQ58Nus6BcCuXg9036Xk4dyH0gBIN4YE0emfpNJSfm9gEvVd9WX8y4iS9Zvd83hSyLh8jGEqWDcDrrkDWUFtJVMm2F2Pj/mhcS6Xz56uGA730FTiclXoF4Txbh0m/AYe0H+zLlkA7dqKCbjRxYPO6S2QB9U71iKPsctN/IPneZ4oi7gL8NNqKXm1H437zT5z0WJA+fqWjMO5GRE7gZLLjKhudPW7q7sft5FvLYcaDGOZZH6At5fluc8WimwVxvMnaoVWaANctVfSlrlz0pAr3CTh1nmdRWG1xtAbDUkOsMaeNJi3tpy6Jwc0xWBB0vg8G7G8WxTOd+saHUMzoztvJoChwN65V83+picklT10R722URgAsEa/vVeiSjhp1i7sdbKfCIbJL8IgzHMmUASkxBvRrAzeNQpTmxpSd+e3AJvVhSSo9IyMmMlx5PTAhL+Wr+z9fWAtkbLvTv/qQduBStcgf0Im4QVO1bB83VX+5EOrwZUOxxo3TteF5lgI1s8E5hWHpBXKWiS/04j+hVCvRy6S7o4mmBXQIPWZfO3ev9NCKMr17tzDVy66WZ3W45XkKrq8ArtZ2AgH6GF538v+rjG4FX4sgDy9y/SB1EhOODuiTBEo6QOK40c9OnlGCJhUt3TlSK5+pk0E6BHCn2wE0U2Tb6VAPBSn09IlAT7phxGlsLvsDYATOEn6/G4L5jt2ii9RqkoIdhy49WFaoyh5oAa5WVh43M0xvif5LDXVNOfH7GpEzVFVE0slEDcCGWCRtPer+MHvQjqgrv1oBWTKdVKPGmwokyKsPJmMyuRS7U58cKQJ/cNv
 VzD5i0MA
 x7QX3xPRWh3gYEP8y8qyXUIJF3Trked4ed6smcKfBc2LsT8ZrPOzz3WqwChmQIMGcFbprkzAfqul/zTkf94hLqLTWZMThXOiZs1yUD9VbY/aZLabnRKcPWCcNbh4KcBsUhYQODXID+I4keDMNrxPE1cvdD69DL0sGh/EEcMHaTYNrXttmm6UzoWW8XVvuBjyB40yPHf1ILWIn6EajTuVIV3VuEedTO17DShPoFSbr2gSKF7P5Ifn3M71TuLcowxFubAz6xu3q/pnhp5RXPdRXGYpZ5+3rYIBf4JrMXDujcmW8r/W3uQKMXg0q69+xpabtXn++lM86Uxu4bv6Zv2e370WT/3h3sAjwQmsnI/FFFST1Vb6GOqm70Nu1SRHweheSeBVIdLaDKp8rffQZ4uUbdiFySZxVyjnHRhMMgvkqzKFO8RH3IhX906QZlPi6f//VrBna8R/fBb0Z9UkplIlH7+QRgbk85I0N2iSRoN2wVyw3qzEDFBUohyDcVTfMqeTXuz6sjG3OQNA2QKFua+/J1XFggpfz06SH8g/j2frERO5VPyAqUritFGfmBJxPYjTIF2e5xEml6QcNjR4ZlxTvf3BcPAWiNO8Oi/Qw5tWhB7U4VFib1ExSO6IdU7J6oW7k77v6NbTmOApEy23aipfqaf8fdo1myUk/Fbb0yUKJBi6wd3t0drn0Z3tRA/kkQj4WWqj2pL1AXDh9XOM3aTS+8V8xaTkcIrKmrIk+pm+yHBlgKTNf1ouVZPdfLRH3iQTppHtRCzaWzjui+WMLhpt/F972jFMD270SflgTmlMHwxam/XtvL7jE3RKQalTMT8qKYkUdlcnd6z3PsXKDSZ92PfS0mU4xN7+fkrR63hYRCLghguun/7j8ZFxw2h+4ZWL30q63gpl+LaYmZlme0pUYeu5tvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests/mm/memory-failure: accept EIO from close after poisoning dirty data
Date: Mon, 23 Nov 2026 19:38:37 -0800

On overlayfs with a virtiofs upper, poisoning a dirty page makes fsync()
return -EIO as expected. close() can return -EIO again after ftruncate()
removes the poisoned page. The selftest currently fails because it requires
close() to return zero after fsync() has reported the error.

Accept a second -EIO from close() only in the hard-poison dirty-page test,
where fsync() has already been checked for -EIO. Continue to reject other
close() errors. With the virtiofs export owned by the daemon's UID and GID,
all ten overlayfs tests pass with no skips; before this change the dirty
hard-poison case failed at close().

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: German Maglione <gmaglione@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Eugenio Pérez <eperezma@redhat.com>
Cc: Kurt Lin <lylin1023@gmail.com>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>

 tools/testing/selftests/mm/memory-failure.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/tools/testing/selftests/mm/memory-failure.c~selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-7
+++ a/tools/testing/selftests/mm/memory-failure.c
@@ -468,8 +468,14 @@ TEST_F(memory_failure, dirty_pagecache)
 	 * fails. Close while the file is still linked. Remove the name
 	 * before checking the result so a failed close cannot leave a file
 	 * for the next test.
+	 *
+	 * With a virtiofs upper, overlayfs can also report -EIO from close()
+	 * after fsync() has reported the poisoned dirty page. Accept this
+	 * second error only for the hard-poison test and only if it is -EIO.
 	 */
 	ret = close(fd);
+	if (ret < 0 && variant->type == MADV_HARD)
+		ret = errno == EIO ? 0 : ret;
 	unlink(fname);
 	ASSERT_EQ(ret, 0);
 }
_

