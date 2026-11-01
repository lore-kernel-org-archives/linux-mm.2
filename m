Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9012606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 23:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=inria.fr header.i=@inria.fr header.a=rsa-sha256 header.s=dc header.b=sur1vkFH
Received: by kanga.kvack.org (Postfix)
	id 5DCEE6B00EF; Sun,  1 Nov 2026 18:20:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58DBC6B05B1; Sun,  1 Nov 2026 18:20:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47C366B05B2; Sun,  1 Nov 2026 18:20:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 106AF6B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 18:20:50 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6AF59A0B10
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 23:20:49 +0000 (UTC)
X-FDA: 85388122218.15.4018FF5
Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
	by imf09.hostedemail.com (Postfix) with ESMTP id 97F0D140008
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 23:20:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=inria.fr header.s=dc header.b=sur1vkFH;
	dmarc=pass (policy=none) header.from=inria.fr;
	spf=pass (imf09.hostedemail.com: domain of julia.lawall@inria.fr designates 192.134.164.104 as permitted sender) smtp.mailfrom=julia.lawall@inria.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793575247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=DN2qS6zGxd+41Wpysh4jKjE7aUcT+0wcXmczyVLoNZ4=;
	b=u4EHL900HUzHPIbqAzFRJRKfD9wqnTREkeWQgdo20PWkMXwtGfjOJGwqEhMhB/7z122ztq
	JmcESdf6Bm4KoDvx0XVBKGmy6PiGzxlnezA3sV8KudH8PjsA5NLa531hGIR6CtOpD6RJDN
	68KjAhGLvgJfp6c4tm5gSvHqHy/cPiU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=inria.fr header.s=dc header.b=sur1vkFH;
	dmarc=pass (policy=none) header.from=inria.fr;
	spf=pass (imf09.hostedemail.com: domain of julia.lawall@inria.fr designates 192.134.164.104 as permitted sender) smtp.mailfrom=julia.lawall@inria.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793575247;
	b=whK+/ptIW4oXCaaWHZSSEoEG3LlpoeWyh0aKsM7/ND9KUbNkYaxbMIOM5pik/9uf1nxBnB
	tjQyFSAu5xJ19uQJa+AlnzegILDle4EoJ4T3lhYkVsRhVSpO0Km8pmNXJW6vVbfyQTBO64
	p+W0J40O4oBPOgVCOvmqT8Jw4CGBNoQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=DN2qS6zGxd+41Wpysh4jKjE7aUcT+0wcXmczyVLoNZ4=;
  b=sur1vkFHUFM4tdopFk453RMy0yzNeGFzo15QkmRsOjong5vtylwkc2Mg
   b2acZclxfvTsSwhszQpKDwTsQT97YcvS3/d27hRinjCiHZvg3c02W3BXH
   ViK4uQdDW8dFQnry4i8jpSmnV9m8yI6ot/dBYRKFVWnDv6msSPNJop3Tc
   k=;
X-CSE-ConnectionGUID: seC/1H/YRD2C1QvPGX9PXw==
X-CSE-MsgGUID: 4emA+J89SAm/t9cYuuNo8g==
X-IronPort-AV: E=Sophos;i="6.27,190,1787004000"; 
   d="scan'208";a="161430623"
Received: from 88-188-149-159.subs.proxad.net (HELO hadrien.home) ([88.188.149.159])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2026 00:20:41 +0100
Date: Mon, 2 Nov 2026 00:20:41 +0100 (CET)
From: Julia Lawall <julia.lawall@inria.fr>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
cc: Andrew Morton <akpm@linux-foundation.org>, 
    Linux Memory Management List <linux-mm@kvack.org>, 
    "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
    Pratyush Yadav <pratyush@kernel.org>, linux-kernel@vger.kernel.org, 
    oe-kbuild-all@lists.linux.de
Subject: kernel/liveupdate/luo_file.c:558:5-13: ERROR: invalid reference to
 the index variable of the iterator on line 553 (fwd)
Message-ID: <a1b79e2b-e960-b6de-9139-fbbd13bfb2b3@inria.fr>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 97F0D140008
X-Stat-Signature: zi5pm8gkhz9p48p8n9xiyut4bzkdsg5o
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793575245-455271
X-HE-Meta: U2FsdGVkX1+rPwYm5W5sYxECTTMcSdjdwsLzQd9Xhk8EsZOo7RvkEOvW1lo1S3NUlDBHL1YArZpjCaPCY7iQBpfpjUmGIMr0Ucxv0qCl5wFK91WotUpC+TPSCmljndpm9EwkjmnN0AJ10GCmRnpYy4YNqo2/ynVW1j+/4lVJ0aqQDhAgX4/Dv3hkS0/1rYu5IK9gpVko8Mx/b1FYZ1km98nYYhuwnLRkOdtzJbXmQRQ3jrR79rSL/hmTdJ/yLE0w5g5aYHH7bSi1jy1MFgfx++9Yqsv50JeaF8HGWOAtQlsWY/pifKfgvJg0sjYV88byEasDq00ncCfbJR98Ypf+IQbHxjiuDp1nE+Lygf+i1wKV1X/wSSrYvxou8V7scgkH+s2DcBjmgpGxITsQ/6RclTP3TNN3hatGfx+PFWCf6jCBEGJuUVidvAFCgIVfpl6piYb/uOZ50bBDllEnVCttielgey9wdn2TQKgxjgOBJAZbfvlYzylDACzcuYFboBiVxZfGjwVwky4Jb1p2famF83cn9LeVe2k6F8T8WRnxZ3K+L3CD/5+z1o+qDQffDEppKCzkKeSrHTw4opyPG3QvgS8yaOj4d9nmwNa5JisVIiIHrwvfEF9hZ6hRQPofn9QFGWIOqCHCTmbVaBFZCE8SbDPUNl8u4edKtV5rCuWGI8FHfs69dPLvQU0WvD5dVZ2MXzyAp1xtF5DloLXLLnwSerBBYtoL4ufk37dKBvyqHz44pdtOVCUDLpSV0+nfcmbHaK4fs6/EFLDOnOuzbNVFA96QYqpyE0nZbbaNXNC0FcErZme+NeqE5e27FYoq+nHa6YE0COuIROJ2Zm2WeG/FcCrsgrVH6dgXNqCBtK+d/f2FBN2jzoixpXzimE4a5NXPkx91B8QzarCvQxLrSD8mt4G+1dUzOF8DHsZ9k95UwAhWAw068nYR7vGs5yweAVoYULLYYNs70y1+U7cVtc7
 4185l1JM
 kZz2tPbRHA3oZ5I2ENqszlKViavhrhjY9mZ5wX4uGcnJJA9EWzj62wGJcHnJey+s6Au+AZAeY1ua6gYNKWcJcV4sujxigmTQNW3P8QYPMJ9jXaew/cJt2DQFvc5SB5Lc7rCowH0wv+eNJ2kTfF/byga+V9mH6f8RHfLRk6GWclm5simmqlVtEx75/QNkTvxAsOBhnr88Resw5cBF2Qcu3rlOikzPTZTxb4hYt7F3UN3OP7M0yYlK1pXqoZ6nEpD/V2yMZf9FS/Iyu2C184EcNRyQ/ovoUE6xFUkDWfXk5lWz331s3X2y0NwcQj0ARih55ykdNZLNIaXiiXF7L3W3i9grbY8eFkxHzuw9X8GjFd6wfQBO+609qJE+vha1mHJ5+YYA6btk8u20YqVqfmAMKmPh/DLZzgzJj/pvW/+y5uA1YOauXtpCyQ2e1qmwYVSvIOYbxzHuecZn79+poIuVSoh6oAXWboIkpNAlsv19SLw4x+kxMdZX/MfiVe/Xp+UKOJbAGwwUuSUV2ou1z0YPT4GB3aWMGpi/7/eOJma5obBTw9WWv6UwL6jDaxy6Zt9/YUIRgOxjpRet0tTtFFQVG+Tpl25mDkAvVQ4fW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

luo_file may point to something random if the break in the
list_for_each_entry is not taken.

julia

---------- Forwarded message ----------
Date: Mon, 02 Nov 2026 00:06:55 +0100
From: kernel test robot <lkp@intel.com>
To: oe-kbuild@lists.linux.dev
Cc: lkp@intel.com, Julia Lawall <julia.lawall@inria.fr>
Subject: kernel/liveupdate/luo_file.c:558:5-13: ERROR: invalid reference to the
    index variable of the iterator on line 553

BCC: lkp@intel.com
CC: oe-kbuild-all@lists.linux.dev
CC: linux-kernel@vger.kernel.org
TO: Pasha Tatashin <pasha.tatashin@soleen.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Memory Management List <linux-mm@kvack.org>
CC: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
CC: Pratyush Yadav <pratyush@kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
commit: 7c722a7f44e0c1f9714084152226bc7bd644b7e3 liveupdate: luo_file: implement file systems callbacks
date:   11 months ago
:::::: branch date: 2 hours ago
:::::: commit date: 11 months ago
config: x86_64-randconfig-2103-20261101 (https://download.01.org/0day-ci/archive/20261101/202611012349.RESCKElP-lkp@intel.com/config)
compiler: clang version 22.1.8 (https://github.com/llvm/llvm-project ca7933e47d3a3451d81e72ac174dcb5aa28b59d1)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Fixes: 7c722a7f44e0 ("liveupdate: luo_file: implement file systems callbacks")
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Julia Lawall <julia.lawall@inria.fr>
| Closes: https://lore.kernel.org/r/202611012349.RESCKElP-lkp@intel.com/

cocci warnings: (new ones prefixed by >>)
>> kernel/liveupdate/luo_file.c:558:5-13: ERROR: invalid reference to the index variable of the iterator on line 553

vim +558 kernel/liveupdate/luo_file.c

7c722a7f44e0c1 Pasha Tatashin 2025-11-25  517
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  518  /**
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  519   * luo_retrieve_file - Restores a preserved file from a file_set by its token.
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  520   * @file_set: The file_set from which to retrieve the file.
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  521   * @token:    The unique token identifying the file to be restored.
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  522   * @filep:    Output parameter; on success, this is populated with a pointer
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  523   *            to the newly retrieved 'struct file'.
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  524   *
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  525   * This function is the primary mechanism for recreating a file in the new
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  526   * kernel after a live update. It searches the file_set's list of deserialized
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  527   * files for an entry matching the provided @token.
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  528   *
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  529   * The operation is idempotent: if a file has already been successfully
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  530   * retrieved, this function will simply return a pointer to the existing
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  531   * 'struct file' and report success without re-executing the retrieve
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  532   * operation. This is handled by checking the 'retrieved' flag under a lock.
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  533   *
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  534   * File retrieval can happen in any order; it is not bound by the order of
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  535   * preservation.
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  536   *
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  537   * Context: Can be called from an ioctl or other in-kernel code in the new
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  538   *          kernel.
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  539   * Return: 0 on success. Returns a negative errno on failure:
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  540   *         -ENOENT if no file with the matching token is found.
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  541   *         Any error code returned by the handler's .retrieve() op.
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  542   */
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  543  int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  544  		      struct file **filep)
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  545  {
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  546  	struct liveupdate_file_op_args args = {0};
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  547  	struct luo_file *luo_file;
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  548  	int err;
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  549
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  550  	if (list_empty(&file_set->files_list))
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  551  		return -ENOENT;
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  552
7c722a7f44e0c1 Pasha Tatashin 2025-11-25 @553  	list_for_each_entry(luo_file, &file_set->files_list, list) {
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  554  		if (luo_file->token == token)
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  555  			break;
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  556  	}
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  557
7c722a7f44e0c1 Pasha Tatashin 2025-11-25 @558  	if (luo_file->token != token)
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  559  		return -ENOENT;
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  560
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  561  	guard(mutex)(&luo_file->mutex);
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  562  	if (luo_file->retrieved) {
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  563  		/*
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  564  		 * Someone is asking for this file again, so get a reference
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  565  		 * for them.
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  566  		 */
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  567  		get_file(luo_file->file);
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  568  		*filep = luo_file->file;
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  569  		return 0;
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  570  	}
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  571
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  572  	args.handler = luo_file->fh;
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  573  	args.serialized_data = luo_file->serialized_data;
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  574  	err = luo_file->fh->ops->retrieve(&args);
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  575  	if (!err) {
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  576  		luo_file->file = args.file;
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  577
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  578  		/* Get reference so we can keep this file in LUO until finish */
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  579  		get_file(luo_file->file);
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  580  		*filep = luo_file->file;
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  581  		luo_file->retrieved = true;
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  582  	}
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  583
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  584  	return err;
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  585  }
7c722a7f44e0c1 Pasha Tatashin 2025-11-25  586

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

