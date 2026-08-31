Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8F44C624C6
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 14:26:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F57D6B0096; Mon, 31 Aug 2026 10:26:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A5B76B009E; Mon, 31 Aug 2026 10:26:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16E766B0096; Mon, 31 Aug 2026 10:26:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E5D836B0096
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:26:27 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6D8D8A016D
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:26:27 +0000 (UTC)
X-FDA: 85161790014.20.80221A8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id D5D5516000E
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:26:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OHlujUnD;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788186385;
	b=lxvFJSmAtMM/ko3k7uFvuSACKngqMVOQI7oWadqh4XAF2o2HFnx6NnEzwVAI1zY34svQaa
	f3LICtv4V7L36zc1GG+3zm7tQNHmlPWzX9scE6NsQ6JFfZJJjiw03sBbdO3cj7ZsnbcDkw
	2Lg21N+RCGiZwIc2BR33SsvwQijpblk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OHlujUnD;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788186385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LAx08zJG2wc5FyCWbkPrWuUIZaKIhJkgRdTbl/CuRIw=;
	b=3rAlQpEzuJgJtsOSu6Bph7MA9zIq4oqh4V5H3n8SU9TVdjpHI3dj+Q/RS84Ykq0KRFtqV8
	jYdZZCkUnlBMH5D/JuVcY4RCVbQUYBZPvwGA5iVaAlAR6OzrPA2PKZRvJnsuhxuhGfczSN
	7DxPqv0vTJJy0MhMFMVWoFnapdWnCtQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 75EFE60200;
	Mon, 31 Aug 2026 14:26:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAE011F00ADB;
	Mon, 31 Aug 2026 14:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788186385;
	bh=LAx08zJG2wc5FyCWbkPrWuUIZaKIhJkgRdTbl/CuRIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OHlujUnDKJ74pdai6cyj34+LE81FhNPaOCEGRuPRC+P4PskyejWBBZQFhJuAhAChb
	 I4gC+FZY15URgsc3yuzzBPzMELVnnn4TwdM6CLD3OVYCON+SHDqskaxY5sMs7WaUiQ
	 zVxSe3Gy1Og95VTpniMewDkmQ7RGGiOTa9OcxzhFV61tZTxDGxN/rMYMLps++TPRVr
	 P/HlrMtt+EFaDS2BbFqFAoRJ/SXIfDiCzw+J+73dM1zkagurkzWBzgYGnGBC/Cbg2k
	 uMUhEpkQzQbzv+hReiMYnqPPE20WcTUJ9S1bwFX3+pmNgrXr63UilGtufhXvQ/3zij
	 G8q46AjDIAJNw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hari Mishal <harimishal1@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 4/7] selftests/damon/sysfs.py: clean up sh processes used for obsolete_target test
Date: Mon, 31 Aug 2026 07:26:06 -0700
Message-ID: <20260831142611.77572-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260831142611.77572-1-sj@kernel.org>
References: <20260831142611.77572-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D5D5516000E
X-Stat-Signature: p4w9816b46zqmqnmmp5fmhgnhc9rdn7k
X-Rspam-User: 
X-HE-Tag: 1788186385-422071
X-HE-Meta: U2FsdGVkX19CXBv2zT4C6+rA/c1N8QmdPvchEyR4mubQFXqyycfyzMb6Q9S/CuxWm7FOVzp8GvtxIJaqewmfW+Zl1SbkN8Ws4LiXCPxv2UTsNXvGPc+s6A3gySQwW4ItQxJ+vlW4tfXxMbCep3R0cBAkchWi9mDvfXc/5DHXjzRtqGe0tmBvFEigob8JAA/bL1+q1s/eGE7s3aRAtM7M6Q2FbmARsTToMuN3BHObt0mKU7RPO1hehoCp6CPTB9YgsA46H9/B684xFv5iE6DWUa8T+f2u9CUIYs6mJT9r/G0hck0Hr167lcSi8t/1dQ7hMwlpidamnQliZQlkHEh0vx8/595O0trVbbY+nX+D16J8EbY78xQ1gTEkoSFvGFGQbJzFFP325X4FarSB2Yo1nUrNMpfHjJxQhomGpq94Mn5JI1BqK4IjXUK4wHHXEi7qROna42yWEZmViGebSZjtDHix0EBJ6iePQ/6hVBFZ+cOeRGA8Er/YF2YI4nIj7Hm8VP85+IqUEi1KtgtIhXqMkHgMvglB0U14Mw3dr3eum1tjSorm60ceNwytikaonufkBFH9td1nAXm5NNI/RX6X33IEwVl68yqgE08lR1ePyL2GPVDYGdlFqG3+7YyYVkXKcsMBQ/24+jIO26EVk9P3JkIhybbkK49oAhull8geD85KMnKPple3EcFB1aOLl0HkZETvG1kOemveNVZNQrSQwvpIU+adnTir5UdTlFLENOVIhhwb65Bvkq/Bg6rhVuz1TxVjWsJgN1zDchjcbGecej50D76zSbgeUhv8ukGp/FgXSXPr4PW8LhNUHMYu7AV+g7FeDHQUUyZeiM9RPVVMOA3Lz3ahTsNcyh/9Lotu73W6MNtWVVWVdb1f219PUerDQaH2ZRdXbRk7jXgtZy9i/lecQUzkcHszXmVN654A0fjKlxIoRkNjUIbavFOmEHJNOh5F6ryZfMFvHrhD7uz
 902PYt1n
 PEeY6r6UmcukcaKTHHJ3oRbf0ikyirUnAUDQe94bdy45kzwS+6GsoL0Y5btWwlvGJ9w3+jwv2nrp9YvA5nEHzibFIUMRZQf7slfOrxXKxa4DpkMENrKJwwtgtEK82vR1bN16V9y1z1bRFxOWxevJ2CpVRauWACqv2q1RxPaQqYRkABbpqUAQkHuWFIvyfzk8KP2zL/UvG/UZaEQbPUMDezM4ShRrcyY8Pty0WoTkvbCCLgqFcAwVu9Vl/uSj7PnwRS+z9D8DE1+HTeeWww9ch5Zfy7eWh12+uV2rSYXerI0g9gZ8Q7Kmvc7SqxbTc7gfRQNO2IFaX80VwvWMyItdB/vDk7SDNI1zBWQ7mFIZvxlW2C6c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hari Mishal <harimishal1@gmail.com>

The obsolete_target test spawns three sh processes and uses their pids
as DAMON monitoring targets.  These processes are never terminated or
waited on, so they are left running (or become zombies) as orphaned
children after the test program exits.

Terminate each process and communicate() with it after the targets are
no longer needed, so it exits and gets reaped instead of being leaked.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Hari Mishal <harimishal1@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v2
- v2: https://lore.kernel.org/20260722012349.9738-1-harimishal1@gmail.com
- Collect R-b: from SJ.
- Rebase to latest mm-new.
Changes from v1
- v1: https://lore.kernel.org/20260721190404.135937-1-harimishal1@gmail.com
- Terminate each sh process directly instead of giving it its own stdin
  pipe to close, dropping the stdin=PIPE changes and shrinking the diff.

 tools/testing/selftests/damon/sysfs.py | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index 3ffa054b63867..88a26422ff44c 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -385,6 +385,10 @@ def main():
     assert_ctxs_committed(kdamonds)
     kdamonds.stop()
 
+    for proc in (proc1, proc2, proc3):
+        proc.terminate()
+        proc.communicate()
+
     test_memcg_filter_memcg_path_staging()
 
 if __name__ == '__main__':
-- 
2.47.3

