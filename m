Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 817596070B0A
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 01:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BlE1xod5
Received: by kanga.kvack.org (Postfix)
	id 978016B05B5; Sun,  8 Nov 2026 20:23:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9506C6B05B7; Sun,  8 Nov 2026 20:23:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8673F6B05B8; Sun,  8 Nov 2026 20:23:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 568266B05B5
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:23:17 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E6A0E1A054E
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 01:23:16 +0000 (UTC)
X-FDA: 85413832392.15.5428FF5
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1985940005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 01:23:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=BlE1xod5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794187395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yd5+TdsEc/1kR6XeHOmWBxFOLTJkBLfiUyBjyyrqsyk=;
	b=s3pQ1JXb/IbonjLSC8IgIGJ9HJW15/WUNGFHGmY3QNvg8S2jc5FZ05OKrJihFqljhpCngX
	2zQbNeXqSrAi37gG0wLC0PkLKqqBcT+r1X0zh/ljHmOjbCE1AS86pYQaT9Va8mNXT+Vjuw
	0sh9Avcv/WQScgqF0BtmANQFSlvrbBU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794187395;
	b=vIefw41LcYQAOejyVOeMV1zOmv7betwRBo3ZTY249KV/xeXYE1b1av8JFV/25Gp+g3VYpY
	DV92/Ek4f1rR5wGk6/Mt1JGFzIXiPW2FLc+XoifktAN8NTAbEAEfrNb9fOTEfEzrG9PfAN
	bLH0Bv7Xr/rTbVzw4BXlwO8vGg5tfFg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=BlE1xod5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-1ae58d17cd9so82875c88.1
        for <linux-mm@kvack.org>; Sun, 08 Nov 2026 17:23:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794187394; x=1794792194; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Yd5+TdsEc/1kR6XeHOmWBxFOLTJkBLfiUyBjyyrqsyk=;
        b=BlE1xod5xM3PHRkPrSH4wPMvWv5dAefHkHAwX8ZeQC4bwo0xGm+1OAQV5iiRnSGhgQ
         XFHI4ZnfBZYA9Qf8XrDhGkhnGT0HnAUr/agAVfBi0OsElcrPyWwW16w91m32k/eTM9qA
         xTBLaneEwmzxtCbFqbdsQHZ0doefHBIrushCog4Bh/+vuATSdHpXvE7wt0Ux6W9aocMC
         Y//FzxoRFH6FZs7wNV2PmVOsaqhg06BkLoTS5+ZOaJLHk9lEXJ9iVIkKfHeXn3m8+ozd
         HyPB2ckDKlFwNPBHN6TH9ez4YjcVVz/erAm5IF4CUpEaBrvXmNZUpMwC9jiiDvC8up8w
         7QQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794187394; x=1794792194;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Yd5+TdsEc/1kR6XeHOmWBxFOLTJkBLfiUyBjyyrqsyk=;
        b=byDn3rKYbP4UT+1+awi6sjvlnbZW5Hb8UuTuaMUojdk5MBbBdpn9oYoFvik/jPoGl6
         3Irafyj7CT16xNNyqeEcV2O33m1qplov2iWSI+yXyXOy8I93Ta0wT1cIcMT7uBx8wZtN
         xI76FU1PNh+zUYD23WazQlHbUtbNqqY2dwYkyEJWQnbhNrmcA8fAWDGEPXh7LlDV97iL
         dNGVfpO0dcDBfws7FDgpzgthq1kGCxWPO+4iz2EkhLY1FtcpdMAWVfcvk+SGxOxmdLYP
         sjMq2BsoM7AZ1Wn8W1oaJu+KQfU/2wNH6Bm2B0FTbJEaJuwTKYoYfuh3Ixtuor83bjqL
         iUEA==
X-Gm-Message-State: APuU4Z+NbTKLyhz5bCBYlpf/QdRCMAlCHz0/gKdmrHGlDjbVQG7AkCOu
	8gybUAZjqNA6quwWkQiuIaTqqPPLLGRLJKiiSrxJFKLFnyBidxJzJyuX
X-Gm-Gg: AYBFou0dgwuit04AKj5Q+hnG6Gil8FXeN5M/DamTKrMMorlsXgQ9mMPhkbBEyudhzxC
	0pAa/h7JJF0MwZOBcJqVduEPum/Pg84kTJFwPJZMDh6miZvRCuDFXy5E04yBl4KDlx/mAiyj4t2
	v4lDcS+A6a1cnTZK4X9R7/C4Bnw+DIXXccgu+qTvH5+n0VhmSRM/x29e1+cfVR0c2yysPRmwzCZ
	o4wClKAyNJhLnci2gVYRYkaGO6gI8LwRLCTMSiKIwwWeR4Df8PVmGe3odYwIOoF7UKr9PVAmwCN
	zqFiq/NUgCMNJ/i7yqpGLGD22gTD9JoMpLs8TApVpB3ZvFyiVfMRaskkcNnvYWn5BKevvZAMqf6
	wQjuw8gNWFgwpHrMVl6DChQgiMACU7btl2klPW/VXnVV3yPmsghQ3Pcvrp2nE6ol2gOOSzYFQYz
	DHveglGxyzbEw4mRHwH6XcNY020+Dxf48/pZthpuCooXLTHEuX3cOsYpGLeujpvkmvus/8q9t2X
	Puhf7xtkjqGtf4c+zn+KoS3VcFjmHOF8TmGj5lww0BNeuYJOP1ygrk+uLcwABCgkHpxju+/Aq2V
	ZRvgLcukXwDryt/bs25fQeIY
X-Received: by 2002:a05:701b:420f:10b0:1ab:6b10:461 with SMTP id a92af1059eb24-1b39ff1d2famr4082012c88.45.1794187393835;
        Sun, 08 Nov 2026 17:23:13 -0800 (PST)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3771ea85bsm9428226c88.18.2026.11.08.17.23.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 17:23:13 -0800 (PST)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Sun, 08 Nov 2026 20:22:52 -0500
Subject: [PATCH v4 3/5] selftests/mm: fail KSM helpers on short reads and
 writes
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261108-bug-mm-ksm-smart-scan-align-skips-v4-3-86be8fe77e7a@gmail.com>
References: <20261108-bug-mm-ksm-smart-scan-align-skips-v4-0-86be8fe77e7a@gmail.com>
In-Reply-To: <20261108-bug-mm-ksm-smart-scan-align-skips-v4-0-86be8fe77e7a@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Xu Xin <xu.xin@linux.dev>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Stefan Roesch <shr@devkernel.io>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
 Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0
X-Stat-Signature: 4hz7cdqo6qxmg6orwzhzku6o6kcq9iqy
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1985940005
X-HE-Tag: 1794187394-281170
X-HE-Meta: U2FsdGVkX1/9XvKxDAj9WUvNxMWH61bi7FAN+EthYU+LUew+O//su+3oog9J4ZgERJ9f/Xq4UMhxNDXFMep7mqV0Db9GoUAgqGyR0lZqIWT4BSY6xYK/AXOyF/NgAC+eBaxXesjhZAxIIN7RcHyKAFf03Y/iTaU+PDPsXyb+2KyEz+7VDLdwm/bhpl9xy7b/47ZCJWCE6Ui85feYca8ZSHWS5+nGSN0C37UKRx6ZK/PmkbXeMGpRYA+vZKYTQjSjBqt9LKVWuBItqeiLyG2p5zQifba9J+lsVflD/b7nEN10vuWWhSmHNePs4gHOQ2vN/OX1jtnoce/TXM8/dvw+0fMJI9Ra+JFp0XtehJmPsk2DCIuCb5qJwCR0AfrGB66YZ09muOapzPSw+5k/GsWBGP4tZcIY7PocxzkzQAMrzis0qX4/NmzpAsm646OFoo/EIj5Jt1I9IEi1tRwes+WfxjYKyJurXFn9xIpJFwBKFxOvuvf1/fpHYm8nU4kThlHq5MTLs070Gm8jBSmBypljThhYFbMzA6vEvrntAcWPJyoohRVYIdCLo8UJMP+62e8uIIY9hf2lIRqBUf7lXTtxZEHZmmIQ6nZtuh64nhEQC8K0MBJc3hk88imyuBPsvkaJj/sT+iPgKQySwomBnA1TcTFTgGoh4z144uUe5fV8aZy076lziXFV5U9p0OyC2iE5F7Gz9/GnsMvuy/CfuRwas37hq/UY7pjHwp1jJZu69GXvO1/uUX+XRf9Kz6zPw9tIjF6RnW0zr7IszpzpV4FBAMXbLRMWpHhFAOZqFhpEVQx/T8lpi+9w5h+8Qu1H8coZXQRsx5SFyOV3zIUvBf/4RY5GskvrD6lp3I9hjlxSVPyBxHmq2FppuWcHf3X+xiG8rpP092ga9edJXnl8MU+b1f6dkzP5QiF8FEqx15Uo/9ZMtybnjLQpl3Wu07MM/IiPhy853mea+eRiwzvuaoc
 JLkzHJ92
 hSgXXhO99xQSXXobW83LowkpxKOWVIXlsX2SREHISRmoHVPMBiNQja0jaDemuFc99y03W7G686s0gE6LH+jueXeZSTErTmbmi2bIYlyjAfgTzxH1craUImB8A+UJCpw27w9yZuzWoEe7Y/uUNf/SeVZ3lz6oQCjclxLxF1V1NnsIndQ2fAp9gQ3MxED6PHcFiYit9rxB32dwT8DbQ9jTg2947xHPcEZYirapIhEZHf30qliV7delqPz+azEKTNNZejRFepCZWmyZ/s0h7jcXgo+5D9/K9cqr4dHRDlgAfSc4X5PEIzLgS9oKk2I495eiYmTiAKcmyqnDbx6my+bTlXXgFUOl+wQv2/Ut+qJWnASElWFguwnVG1TvCS/oMRbJ+DvrVWjbs0waKz9ydH9BB9FgeYoCS1pMBcAgzoooFX6O8QWiYBrlaUGvrtD6Gi4zUbyAmp1Akq6KDe2nZQ5N9ck7yRaD+O8x9zaQxnp1U8O7dj4dXQC/w5ce1tw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The KSM helpers in vm_util read and write KSM's sysfs and procfs files
with a single pread() or write(), and return -errno when the call does
not transfer what they asked for.

A read of zero bytes or a short write leaves errno at 0, so the helpers
then return 0, which their callers take as a value of 0 or as a write
that took effect. A short write of run makes ksm_start() wait for scans
of a ksmd that never started, a short read of full_scans makes it wait
for scans that never seem to complete, and short reads of
ksm_merging_pages or ksm_stat and a short write of use_zero_pages make
cases fail that should have been skipped.

Return -errno only when the call fails, and -EIO when it transfers less
than asked, so that callers skip or fail as they do on other errors.
Forcing each short read or write with an LD_PRELOAD shim on
ksm_functional_tests:

  short read or write of   before                    after
  run                      cases fail, then hangs    all skipped
  full_scans               hangs in the first case   all skipped
  ksm_merging_pages        9 of 11 cases fail        all skipped
  ksm_stat                 zero page case fails      zero page case skipped
  use_zero_pages           zero page case fails      zero page case skipped

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
The checks come from 93fb70aa5904 ("selftests/vm: add KSM unmerge
tests"), 3d0745e59c84 ("selftest: add a testcase of ksm zero pages")
and 42096aa24b82 ("selftest/mm: ksm_functional_tests: test in
mmap_and_merge_range() if anything got merged"), and b27f292de6b1
("selftests/mm: put general ksm operation into vm_util") turned the
use_zero_pages check into one of them. There are no Fixes tags, as
only short reads and writes forced with the shim hit them, and the
helpers are in vm_util only since v6.18.
---
 tools/testing/selftests/mm/vm_util.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 515031b8283da..caea045fa7d46 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -920,6 +920,8 @@ long ksm_get_self_zero_pages(void)
 	close(proc_self_ksm_stat_fd);
 	if (read_size < 0)
 		return -errno;
+	if (!read_size)
+		return -EIO;
 
 	buf[read_size] = 0;
 
@@ -944,8 +946,10 @@ long ksm_get_self_merging_pages(void)
 
 	ret = pread(proc_self_ksm_merging_pages_fd, buf, sizeof(buf) - 1, 0);
 	close(proc_self_ksm_merging_pages_fd);
-	if (ret <= 0)
+	if (ret < 0)
 		return -errno;
+	if (!ret)
+		return -EIO;
 	buf[ret] = 0;
 
 	return strtol(buf, NULL, 10);
@@ -963,8 +967,10 @@ long ksm_get_full_scans(void)
 
 	ret = pread(ksm_full_scans_fd, buf, sizeof(buf) - 1, 0);
 	close(ksm_full_scans_fd);
-	if (ret <= 0)
+	if (ret < 0)
 		return -errno;
+	if (!ret)
+		return -EIO;
 	buf[ret] = 0;
 
 	return strtol(buf, NULL, 10);
@@ -981,7 +987,9 @@ int ksm_use_zero_pages(void)
 
 	ret = write(ksm_use_zero_pages_fd, "1", 1);
 	close(ksm_use_zero_pages_fd);
-	return ret == 1 ? 0 : -errno;
+	if (ret < 0)
+		return -errno;
+	return ret == 1 ? 0 : -EIO;
 }
 
 int ksm_start(void)
@@ -1002,8 +1010,10 @@ int ksm_start(void)
 	}
 	ret = write(ksm_fd, "1", 1);
 	close(ksm_fd);
-	if (ret != 1)
+	if (ret < 0)
 		return -errno;
+	if (ret != 1)
+		return -EIO;
 	do {
 		end_scans = ksm_get_full_scans();
 		if (end_scans < 0)
@@ -1024,7 +1034,9 @@ int ksm_stop(void)
 
 	ret = write(ksm_fd, "2", 1);
 	close(ksm_fd);
-	return ret == 1 ? 0 : -errno;
+	if (ret < 0)
+		return -errno;
+	return ret == 1 ? 0 : -EIO;
 }
 
 int get_hardware_corrupted_size(unsigned long *val)

-- 
2.43.0


