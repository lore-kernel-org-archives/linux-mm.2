Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92F56F54AD2
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 16:09:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5E1D6B0089; Tue, 24 Mar 2026 12:09:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0F026B008A; Tue, 24 Mar 2026 12:09:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D24D06B008C; Tue, 24 Mar 2026 12:09:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C56046B0089
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 12:09:31 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 75E3EB7D82
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 16:09:31 +0000 (UTC)
X-FDA: 84581441742.22.307DA01
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id A653240007
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 16:09:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=07YayBE8;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=07YayBE8;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774368569; a=rsa-sha256;
	cv=none;
	b=bQf+6qd1jASgQkY8mf4W1djpA8vuvKmmMrBnvctGwyNe0lnNuBbu6e4x35sE5ziYFSpqZL
	3X1R9oYicMbHjb7lSYo8swQUPePJEYBRkNwYEU5utT/hLt5COGqHoAKRDwH59VA5rOuWBd
	keVjJFvJ6I8HTyHPy300bAVcZXlriK4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774368569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GK0mAz/bAi96ru9zbnEYP0yBc0qad84ZcGATjWdLzF8=;
	b=p1RWJtUPuBKKT0g+gJlqOjCTg8M39kbylzm8ulykYLAEkjZWSd58ar8/5R37zDPJr5Up2K
	78iqMp7Mr5svcniIU+ifMFJPUziwSXzJ9YJKLcwE7QRZeY9d55HfzT7eREN6lhWAoQwMR2
	ZCUWfbAXkyEzYrvPbxBYXyRop1iLv/E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 063EF60120;
	Tue, 24 Mar 2026 16:09:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13225C19424;
	Tue, 24 Mar 2026 16:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774368568;
	bh=+VNZwLf2hFq4tQFgtsQXYLO62uURuRRQHVBaVT3NuT8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=07YayBE8Ncq4/YfhiSmUk+V5imcNswHCuEhleALDb/hAo8TDnKVgGaZP09RaZ/R4V
	 bqkotKSQTkLaYp17fVGuZ72YNGJ1WxMQGPFZwyKWSPb350yaYBwuwiWK3jHVmTXI7o
	 TdoP18t/YDq0Hdhvd8z+OmffHCx6lyMsO1xyJToU=
Date: Tue, 24 Mar 2026 09:09:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chunyu Hu <chuhu@redhat.com>
Cc: david@kernel.org, shuah@kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev
Subject: Re: [PATCH v6 0/6] selftests/mm: skip several tests when thp is not
 available
Message-Id: <20260324090927.eeacb7987d22ed8ba13fada2@linux-foundation.org>
In-Reply-To: <20260324013316.2590422-1-chuhu@redhat.com>
References: <20260324013316.2590422-1-chuhu@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A653240007
X-Stat-Signature: tq4rr9cqxr686y5g6q47ipkb3k9m6cwp
X-Rspam-User: 
X-HE-Tag: 1774368569-866147
X-HE-Meta: U2FsdGVkX18D4AmQsnDA2Mfz8esXbyQ+/vgZHmIcIMXZtd+HMomyi51GQ39Zo3bZSLgwCzRNMnMxZiRD3sAXc4zVGIC0vvOfi0Rzf2Rz2iXzdqhsl5B69mAm9j8tlCBelDihrUC4vjritUD//xzFMHE24EJvFcgPOU8hDbUf2XvqIvIieNmQYazFJHoiWSV7N9A1druFWyfWVEZlULVENj+hwhyYocc7wKsRS5QJxbpFykyohbL7R/6PfpJyqQqXTc+wF1NkKLRTSkOTIWLXbXRJvkQJQk6qRoDjWmQc89m6Rph2ErctJUEqLHcQGsRBpbwLiEBtzHSEMAbNIDnwABfKsVGuU73CVa7Xc+OhmhN5109DDEJUVZurFrJ9Og4M0h6IcQhkqr8mt+75XpSJkpX2w4wi8TNsFUC+CXfTtyVbvumSn+bx87o5eoKsmagHxL8GwWbvH9/8KFkG3U/eEZapvRec5ch/MJYg59Kc8EewcW/MUJyvlvhJUnp+tVd50mcaU556bwLXavYM4L35psGW4vMCenO6wKdCI4sPbx4e/0DbH+6vV/vsz/QOa9Osp4iFy2ZN+WNzm+aWENEP3AGzAKR/9GoXbHDofVPwgChM70p+RZ62AuhYER2k20boYil5GkgA/IuF0yXD53kL4zec7Ay2eJG4viKnrdw3jqw/7b1XKP911YBFnJaDELL0ZWvNrfhY3BDGSPwh0IA6Uun6IMyXmWP1jYmgKZUF/cfwoWMO1URpno0XSUoXw7+QM8S2KzTUdIW8BFixhWEqEkzDus+9h4IAuCThEpwM3VoZt9T+k/SmZ95yGKyfkKvgbjH/uArEm+cD08+Ts8KoE98Mw32A0rE9C09Qz258qSM9B8td0n8AsFxIMcx/HrXmc/Jw2J7QM/MwPc567H4Y6GpbIdcJktfOnVkDRldtG9HzlBQjsWI+reJhMNr2hP7C/oSMC07wieaKmwIUAqY
 8JALs2kl
 xsEL3gVkBCZMUOFGoW8XyAvSUCtl4WePzG/DsRgigQGv4htYR2mn0lry2eeIFT9VVVzII5M5Z4I4/g9EK0fb8GdNFjexQIldWL4sk/TG2F6EA3LshUFOwcVG7tygdhW5pGxwtWIIx9/dYrDgBWO+5RCMx/Qiy8IIsyEo6XN1l2+1CDzfrhKHumVHoj2TOBLRQnRkY4cvjaXIIa3CeGH9/kMHLuJvRYQiDCAIQP9lLWx2fpuYINEoaVtQBWFCHtCL3OTZfyR84H3EEH9Q7dGqOOZzOkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 24 Mar 2026 09:33:10 +0800 Chunyu Hu <chuhu@redhat.com> wrote:

> There are several tests requires transprarent hugepages, when run on thp
> disabled kernel such as realtime kernel, there will be false negative.
> Mark those tests as skip when thp is not available.

Thanks, I updated mm.git's mm-unstable branch to this version.

> Chagnes in v6:
>   - patch 3 add reviewed-by from Lorenzo
>   - patch 4 handle the errno before and after close(), suggested by AI

Here's how v6 altered mm.git:


 tools/testing/selftests/mm/vm_util.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/vm_util.c~b
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -785,15 +785,23 @@ int unpoison_memory(unsigned long pfn)
 
 void write_file(const char *path, const char *buf, size_t buflen)
 {
-	int fd;
+	int fd, saved_errno;
 	ssize_t numwritten;
+	if (buflen < 1)
+		ksft_exit_fail_msg("Incorrect buffer len: %zu\n", buflen);
 
 	fd = open(path, O_WRONLY);
 	if (fd == -1)
 		ksft_exit_fail_msg("%s open failed: %s\n", path, strerror(errno));
 
 	numwritten = write(fd, buf, buflen - 1);
+	saved_errno = errno;
 	close(fd);
+	errno = saved_errno;
 	if (numwritten < 1)
-		ksft_exit_fail_msg("Write failed\n");
+		ksft_exit_fail_msg("%s write(%s) failed: %s\n", path, buf,
+				strerror(errno));
+	if (numwritten != buflen - 1)
+		ksft_exit_fail_msg("%s write(%s) is truncated, expected %zu bytes, got %zd bytes\n",
+				path, buf, buflen - 1, numwritten);
 }
_


