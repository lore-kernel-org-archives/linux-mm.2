Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3F86606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 06:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iptjPr9S
Received: by kanga.kvack.org (Postfix)
	id BE9C76B05B9; Thu, 29 Oct 2026 02:24:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B74106B05B7; Thu, 29 Oct 2026 02:24:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A624B6B05B8; Thu, 29 Oct 2026 02:24:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 83D0D6B05B5
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:24:58 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 09F131C2304
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:24:58 +0000 (UTC)
X-FDA: 85374675876.06.5DEE795
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf03.hostedemail.com (Postfix) with ESMTP id 35FF920005
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:24:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=iptjPr9S;
	spf=pass (imf03.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793255096;
	b=sT/YI2RU56GEu01u+TyccFreY6wsCfzrhfSiHG6dmqj7Rxw9AXW5jYwkheXCSto5EzlmY7
	jEgHO6YtcHUs5THg1Tmg3dpStXcv1n5g7zHwqLjS6ch82HGksPUzcYIakts509AZ+bsaZH
	Bm9Kc7CgS+PqZGYQUX/W2Axqi4P6Ahs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=iptjPr9S;
	spf=pass (imf03.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793255096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8NzBJI6EsRS50iI3ozE0K4oKaJ1QSXdP21FHU7kTXig=;
	b=FOc2zx6cCx2vOhrkboE2PCFsJJf6Jf7lwicEMIMvZ/PzRjbvrqBtUDI8rL0+pD/zTerCT9
	AtcXpOAnh82CCu6mC24ey39bZiN9oOn5YTa+Qc6pnWuoaJgnwuRpyXY+/dtVzaYK2sKm/B
	nQg4bAEvkC5WuTPecqd51XE2F/7Pbz8=
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-14fc585291cso1580556c88.1
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 23:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793255095; x=1793859895; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8NzBJI6EsRS50iI3ozE0K4oKaJ1QSXdP21FHU7kTXig=;
        b=iptjPr9SOm7bYTOnNa+iQoDbx4DdQdusqkHflSJZAN6Jas1jWeo+olPVKSKHBAbDwZ
         FD5mvQoZG8ohmr6HTPvUwIoskfkNYQeCHuHSSWGoQM9f5VlfkVUmxCzuXoVxFvQ9ylyk
         fJCqwRd+FinMR17RMiTn1GiChJJVQqRY1jMQuNHR6G4s4PLEXzBEECOC0dcYwkTfHRXM
         JwWNpV+dj5RvUGVIRtE42QcvmAHIdGiP1+Kcpq7szYn8C5SHOAAzKKYzaMoKyK8nvCp7
         fI4sBj9v8Os8b1wvnFzKgA/7PsO0IMrCnWagXxVaUNJu+INSew9SVl2TbIncSkSEe5Mz
         8t7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793255095; x=1793859895;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8NzBJI6EsRS50iI3ozE0K4oKaJ1QSXdP21FHU7kTXig=;
        b=BLPTkFCWa7Y7kpqfFwHeSCrW6+bVHwEyyRYQtpyD+KMgxjf/jdBxkt3PmEC7RdAsAN
         rOElWfvxJ5fgYowArfF8au7su0hA/rqf1NLHmAKqDusN0OVnCQyF2hFKR9K+vxchef5D
         ivce4wrRkJErHHzEzNehuX2MZa4uEL721bhMZfCttk46wAu7/+GRpTzAEvtA5nCXy7UG
         MKf23gkj0vSNRnAadVNcO7EbwZtTa8USpDBdnyhMkjVHPMChEzUuMWhoW5l7fG70mY9K
         bDs4hErAmv1E9xe7GjCu7ayHfwFNIpnQWlWiMpytyECz+572qxc6Gc8ADWt2ujDrJoiP
         QO8g==
X-Gm-Message-State: AFq9FYKsHQ/PCbdr3Qx64XDflDC2Mx0QiFkY9ytO+1Pr8dPKiDvhREJF
	KCPb7UcC2EfmllmP04Po4H4DO+f12coYmFYxvnHorIsMF/6lfhWbAl//
X-Gm-Gg: AYBFou1zrZmsobdA66AxL90Yu5TKuv1QTBUABiOcGgNfsayTcedW2BhEkWjyufQUVu0
	wBDonF4guw8vq3kSHP1Fra9Y2A1FLd4TiHVhyfppAuDY2yPJNZF/1/G93zMxt1314Iz8C3NCKq5
	FHdb1jSIng/FUScSsfC5qKTzFgq5nFrnBCi668P7GtnvH4hsckHlDlBFjcW15X/TkHZ043CFe51
	Q/9lBAViJnOfH5gkUSgX0ARMMloEFXhWhZTg7TW8MunpLOf91kGQnzrBWsmP0xvgAsJhqxYICZT
	JJP/PxRwXKftTO0bGmm+Q5waWgH3KqTioeVoejl94SHYZhgVOLk5A9npZh0fvw0QVmoolIDQIPY
	PPwfs3xxmUJCyNTKqg0WXKGl7SIANdJdJXcGv7crdB0hF49PiGhMDdKBH7X12tUxmafbRqdXVwg
	f0sc6QB/F8Wr0tiMZQ65W4lRZj6psultaP2Ah9gA7wcZ4lDIzypel2Bt4bCXgoQShGxMlNpYCm+
	8i3z41uKPIGabG5mOQE7Uo/+5OpnDjJ5eBge9G8y56aPKdu5knxXAdnFNQzYRx6LZCIdB8kgA/s
	CG37SO/0JI1ZA3M+6EA296N/
X-Received: by 2002:a05:7022:1003:b0:151:8280:2c1a with SMTP id a92af1059eb24-1a6cfcedf27mr7079202c88.42.1793255094945;
        Wed, 28 Oct 2026 23:24:54 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1aa2f100684sm2152004c88.3.2026.10.28.23.24.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 23:24:54 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Thu, 29 Oct 2026 02:24:36 -0400
Subject: [PATCH v3 2/2] selftests/mm: load xfs before checking for it in
 run_vmtests.sh
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-bug-selftests-mm-run-vmtests-xfs-modprobe-v3-2-16ad772850ee@gmail.com>
References: <20261029-bug-selftests-mm-run-vmtests-xfs-modprobe-v3-0-16ad772850ee@gmail.com>
In-Reply-To: <20261029-bug-selftests-mm-run-vmtests-xfs-modprobe-v3-0-16ad772850ee@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
 Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Rspamd-Queue-Id: 35FF920005
X-Stat-Signature: yrxxmn57ouwms6kgw74r4ywa4pn4qo5p
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793255096-266085
X-HE-Meta: U2FsdGVkX18iPZ93DDPjanONWkh4sGGDDoucrUoswegwBtws2LxhQ744djwtamosSG4O0Sn+vEZAOvtWjZnAfg36wCG0H8jSx/pX+uqkfkhbeX35sKQIfx5KA/zgzXU92JIYNhPll0O/eTeFxJ73zJB++WdExW834NUJy8MeIsMbjdnBT1NA02AYlN/wsYCXpizymp9Unj929cg8FndeFEOEsP223Uh7+lN5ptcfaY8sLhq11ilEIK4rk1UgtVNBXmg6Zt8Wra5FWbX+WH+uPSyalZ/iF9b+ZOEscrENGdagwcMSSF2U7AuBEuAJdGb/pw18/4oX+Yo5KajHYTxRNx3FjYdV5FVoSi6ibr7x3DzAhc4ycg8uLcO7cMKsAb4TWXL7+ZgsGPFXbEuyFt+21/hhCe4hFEPd7oxZ8QP3KdqtZ+mw2XlCdvFkOf0So9pLQgicgsmm9XkNkQNvFteV73WWQy/lGJzkRqWOBDHuiZpbCXrZiZRLi4YpAv1ESoxgQe2kMEhsCo3iwxOoqy3RuUckSHGlsszq6llEOiv8GZpGz7v8iyAw+Tupv4a46JOJc7BvKvMjBhQevGqzmut6/9M0GCbOkZUPBpcwQ48SO2NjaXS7kPCM3FAXmLTj3jdGejHzYSrtTXFGVR9FA/fhqXbkvhk3qsCxihgWbLoZ/WC6hcJx56xDNJFOdkdPW5cdnq7WHta28EIITzGlVNA9+Lw9/Mc/iJAgaJCHCvVZGEZeRI5kLVfd+M03UQDnY6pjOi2Nb1J2G2ek0Mc6LaZTtA+NtXxX77SnGx6rkbco3ATaN9CGDiDI+n55+Cor4Hwjub0GO2gj14EvYqbBYN6tksVJJLT2wheWMZOD7+Xw15eYUR1zcaqAVGws1nm+EyfhOANxdC4N4dX8FhhYPMgArnyHtm07yw3RRUCtU8uaYk8CE/JUP58/ebzx+H+kBbAJ0X1Jk/sWN00r4K4KNjR
 CNO4mtiL
 X5jAHvxMp0v6cxBJPwAHsC4+mwsLPefrooNh2d5AFbliqUdGlIQ7LNiWR1yUTNVHrCFWGQGAI0ERjGF3IxmxM+Y7e7gcEvPO0Okk2fxI8jD/rcYqSUVEsaV8bwKwXpaD4ZAth7g4Ik9FMDZRlcC7ymApV4Ix1QoIyRsoEmG7aADNIQulhjEaW2LEpjkepe/2H/SX3F28eMdklQ93mEouPydxLLMQGrvwmQtHg/rPEJrtHs7bk7Osg4ufZ01/RYhzkUDkxI8NseJ2F7L25evhGAJ4QkcrwwUjVxFO7qKXVIfoae9L9ZG9P85zpfjiznpxhgn2bPjyyoxbw/xiEZpf+Ukw/0bqylOApzgwWOCJot9oZYYcQ5G30HMkWF7DxJJXi9vQn0F+5BPJKycQB+wwYhCQ/ucMMSSO/Y0irwFvhtdEpEwdm2M0riOeHhDnmaub8QmcbHES6p1mEQmdxt3bjJLfN5rbYdn2wpLGP6GQZ1Xv8Bzz5h56NHbeN8bi7DZUtLqHz7EKydKglioL52kMyDKK6E96GTsxTjalL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

run_vmtests.sh creates a loop-mounted XFS for "khugepaged all:file" and
for the pagecache folio split cases of split_huge_page_test, since
tmpfs does not give them large pagecache folios.

It only does so when xfs already shows up in /proc/filesystems. When
xfs is built as a module that is not loaded yet, the check fails, no
XFS is created, "khugepaged all:file" is reported as skipped and every
pagecache folio split case of split_huge_page_test is skipped with "No
large pagecache folio generated".

Load xfs with load_module() when it is not registered yet, so that it
is unloaded again once the script is done. Match xfs as a whole word,
as "selinuxfs" contains it too, as does "vxfs" on kernels before 7.3,
and would otherwise skip the load and leave xfs to be loaded by
mount(). "run_vmtests.sh -t thp" with xfs built as a module and not
loaded:

                                        before    after
  khugepaged all:file                  skipped      run
  skipped split_huge_page_test cases        43        0
  xfs loaded after the run                  no       no
  xfs loaded after the run, with
  selinuxfs or vxfs registered             yes       no

Fixes: fc4d182316bd ("mm: huge_memory: enable debugfs to split huge pages to any order")
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
 tools/testing/selftests/mm/run_vmtests.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index e104a9c6fdefb..b422edc2e2664 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -412,7 +412,7 @@ CATEGORY="thp" run_test ./khugepaged -s 4 all:shmem
 # Try to create XFS if not provided
 if [ -z "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
     if test_selected "thp"; then
-	if grep xfs /proc/filesystems &>/dev/null; then
+	if grep -qw xfs /proc/filesystems || load_module xfs; then
 	    XFS_IMG=$(mktemp /tmp/xfs_img_XXXXXX)
 	    XFS_DIR=$(mktemp -d /tmp/xfs_dir_XXXXXX)
 	    truncate -s 314572800 ${XFS_IMG}

-- 
2.43.0


