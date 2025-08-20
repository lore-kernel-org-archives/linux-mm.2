Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F1E4CA0EE6
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 01:05:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B41676B00C9; Tue, 19 Aug 2025 21:05:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF16F6B00CA; Tue, 19 Aug 2025 21:05:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B8AE6B00CB; Tue, 19 Aug 2025 21:05:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8094D6B00C9
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 21:05:31 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 52A2C138031
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:05:31 +0000 (UTC)
X-FDA: 83795342862.27.01A34A8
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 44F8D20006
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:05:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=E1jkn6uc;
	spf=pass (imf13.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755651929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HbYD1l2iLYYzN9WowdlH5+feA7G9e6IFZDEjiJfik3M=;
	b=BhQdjaWRJc4D6FpwC5lTUNQkxH/bOPZu+Mv1EeZyAqsCBwpjyKN11dPyNp76v50IBDyZfX
	PRVG8bsLhVi2+h1OXHvY9nNVNoCR99/bG+1h3O8FSNx0Xom1JZtM/lfJToHEiNt8kWsBIg
	L0zhkZCuYhNr22Tm0lBDtgunqc0M2DQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755651929; a=rsa-sha256;
	cv=none;
	b=qWh6H8pgOMu6qwizma1+L7u39ilnBNY76p8wE8pgFZQ+VQe7/KXWnFCH64jVCcrLs5l+ZL
	s9gTU4Wa0nPIQDakFX10gZHDO5EoHVpfDJBkh6mz4Mpcka+2I6FanyCcWzGKKkFFwwvCeZ
	g9XbYmSl2lrvrHbFvy3lwyc5mUbo5WU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=E1jkn6uc;
	spf=pass (imf13.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57JLBqrS005563;
	Wed, 20 Aug 2025 01:05:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=HbYD1
	l2iLYYzN9WowdlH5+feA7G9e6IFZDEjiJfik3M=; b=E1jkn6ucUK/gVVlsGu7QL
	8EJjAOIUm/io6qbZVuaFtYjKvOiJZanHf+TEq7rELvmcp841H1MXmBYW3XSzqdUU
	prrJUA44c6Xn7+DYjEe96ZyXBlBpo+mwhm7xH+WHjzb6O+ConDgg8WLSoGLY4/Ky
	p8IprtksQIjnmh49p5oA9guZRzITYgdpGyM7S+5I703qOwYQzMfQ7qFyc0nEs+5x
	wNGwh+8eQrDQPtKHLPBKiNHMiR3RNTWbB2+XUSecdVFH4TDKkFaVtqui5uY2+80Y
	HJRTrVssfgLWvV9yalScIxCuoKouBruky2grh7d+qaS9g5Gk0AXft+eCUksKYKR9
	Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0tsr850-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 01:05:05 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57JNVOUF007290;
	Wed, 20 Aug 2025 01:05:04 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48my3q2a3j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 01:05:04 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 57K14NdY011685;
	Wed, 20 Aug 2025 01:05:03 GMT
Received: from localhost.localdomain (ca-dev60.us.oracle.com [10.129.136.27])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 48my3q29gw-16;
	Wed, 20 Aug 2025 01:05:03 +0000
From: Anthony Yznaga <anthony.yznaga@oracle.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org, andreyknvl@gmail.com, arnd@arndb.de,
        bp@alien8.de, brauner@kernel.org, bsegall@google.com, corbet@lwn.net,
        dave.hansen@linux.intel.com, david@redhat.com,
        dietmar.eggemann@arm.com, ebiederm@xmission.com, hpa@zytor.com,
        jakub.wartak@mailbox.org, jannh@google.com, juri.lelli@redhat.com,
        khalid@kernel.org, liam.howlett@oracle.com, linyongting@bytedance.com,
        lorenzo.stoakes@oracle.com, luto@kernel.org, markhemm@googlemail.com,
        maz@kernel.org, mhiramat@kernel.org, mgorman@suse.de, mhocko@suse.com,
        mingo@redhat.com, muchun.song@linux.dev, neilb@suse.de,
        osalvador@suse.de, pcc@google.com, peterz@infradead.org,
        pfalcato@suse.de, rostedt@goodmis.org, rppt@kernel.org,
        shakeel.butt@linux.dev, surenb@google.com, tglx@linutronix.de,
        vasily.averin@linux.dev, vbabka@suse.cz, vincent.guittot@linaro.org,
        viro@zeniv.linux.org.uk, vschneid@redhat.com, willy@infradead.org,
        x86@kernel.org, xhao@linux.alibaba.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH v3 15/22] mm: create __do_mmap() to take an mm_struct * arg
Date: Tue, 19 Aug 2025 18:04:08 -0700
Message-ID: <20250820010415.699353-16-anthony.yznaga@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250820010415.699353-1-anthony.yznaga@oracle.com>
References: <20250820010415.699353-1-anthony.yznaga@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-19_04,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508200007
X-Proofpoint-GUID: TbbjLz4-bGRIkmOtv-lhbXkJ4biLIzYW
X-Authority-Analysis: v=2.4 cv=S6eAAIsP c=1 sm=1 tr=0 ts=68a51f41 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=2OwXVqhp2XgA:10 a=yPCof4ZbAAAA:8 a=xDz22KVWXZV-ta6dUt0A:9
 a=UhEZJTgQB8St2RibIkdl:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=QOGEsqRv6VhmHaoFNykA:22
X-Proofpoint-ORIG-GUID: TbbjLz4-bGRIkmOtv-lhbXkJ4biLIzYW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfX+3aNG8/E6p++
 4I/UAW+dDyT06eH24CC14bTvgSx5mYxM8Y+AUzyruJr/tjhFmWIipK63mm1MZ02txrWNMaWTECA
 E7J7AQDJXDp9fUfEGx1jQPkQp+egpAuC6wq8v1Y1+3DG59V87QlDoTXq2RdkoDBQAuxV9ZzhoLh
 1EL4R+QRz1+ZWRcs7mTD+je5fjEV0dhb/HQMA3go5oYWey1bw2ULhLOpOLDhfnIi4OpbtFUJ0k5
 EmFCULWx4L36303shUuWSKyMvs+LDDYkxpXm8i4/FaWxv212zAKKn3rzcK455ySkWffkO7wUm/O
 XFNsF0bdfnya6u2B7wLG22BXzyq3+hlVi8ioefq+KQT86Qq8iAkdZoD2SUs3tGBPiGa49pc+9DR
 enx1eRCPQidAfCoO56Q8JlWO/+lq3w==
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 44F8D20006
X-Stat-Signature: o6e6joe8ukjxocygg131f86mom1mu46y
X-HE-Tag: 1755651929-218582
X-HE-Meta: U2FsdGVkX18DMIi6mCrFBUgmjRFOkLU738Of87nxe/80D3fjO1Eu7yHoxIaY3BUGRkTHNcFPO8YJ3IhtThETRmvBxFj/8vLDZbWVnUB9l1iWBW+x3ttf/NNhsqhU9bAyAO95MuCDUtN8BuKMOS+YQH3OvX/1fN5qQRyqRO2WtrH7Oky7k3xfZ9yKIL9hl9Ka1CZXSCD8fETlNfMWTGVB6t/yWWAxnVwp3GPsW7i9HuKAC8ZK7ECvBiMWW17BudX27U+6keYEb39makZj8e6T/2ZJ2pgjzj4gGn7MM1I7c/0P2pyPbZ6QOWwr2hxIe6u+QLpCGBr1xk0KkLPbdQfK2dLUoPFBioyLo4qMTYG2w0kRiYhSKoTbC1lR8w8em8K7nlMze8wp5fUVbCUoj18jObvJzIQJxN1s012cUaZvU9ZD1jZ2wRAzNiz3E2uQ/Xig/bRUcDyMVcwbxS8RlsVSlhyl4CV7sCpqS+Nj2idka2Jw829GuB6MgF6FCQjQfrv5+on9prPG96qwpcGtkP5Dow7ZVRpJe6tsShse4NAVTmwg7XUv1a013ViilgWD/obOZ8ECh1KsfB8Omi7Hb0Y54IsDMIWchDSNZDzamcopvDCKGGEqzwVP8g4Q3zwcoAsAj5bWoRzKpFpiPldSm/f3aXrDFyFiSbIkUONTn5iVhqVX1HiFUzLq6inPnJZqhMHfskhXaGeJQLm7uYpnxaD0BD9vtIEyR4k0JFnkeKhcMzVnw5guXf9BH4e8Cc54reV4RuUZ4+LoSLi825zHjEJXCplE0qCqqKnw4GSW2cLnxYT2sCJv6Q88mZuvUtbBD2RCAeTzEoqN+BgEMQRAstRNi0DWS/S4QTREcmuf0XzdyVLop1PmfO+Ix56NpBpgtS/b9K0lYpA7KUOElV9SHw/LLQG6LborGg/Nx8RolkzX5tAAaaxiGrfNlLY/Z03i++ELHqc4QjGZjqfEvk/d1Ko
 b0aKPk+4
 blqGH5+9R5UV60KGfYfQhlwv4QFDZnjr4Nn7p2JEySfVPqcDxMpy52hk4ss+D3FI6RiSEspJfkw0/VSwHqHUSusaNRFT4UCPEqq72p/bKcoAoann+v+Xu6Z7dsZ6f44IZXE5fkv5iHCDUptiaw66j7DjNbNKTjPJAQzHOObE3YaXh2s2H19iq2v3KvD6IpDJxSWvmqLvylH7utYpu2D0Vpo6IPdCl/ckTYRF//TZpjC3kf2AfNJoJDnO4tROVxg/IQpaJ3PUzexaSCro3ufiXBvo53Su66xvoW8mq2py9/C9vKOfWdfVSW8L/Xf1J3fMXoAja
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for mapping objects into an mshare region, create
__do_mmap() to allow mapping into a specified mm. There are no
functional changes otherwise.

Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
---
 include/linux/mm.h | 16 ++++++++++++++++
 mm/mmap.c          | 10 +++++-----
 mm/vma.c           | 12 ++++++------
 mm/vma.h           |  2 +-
 4 files changed, 28 insertions(+), 12 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 3a8dddb5925a..07e0a15a4618 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3434,10 +3434,26 @@ get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
 	return __get_unmapped_area(file, addr, len, pgoff, flags, 0);
 }
 
+#ifdef CONFIG_MMU
+unsigned long __do_mmap(struct file *file, unsigned long addr,
+	unsigned long len, unsigned long prot, unsigned long flags,
+	vm_flags_t vm_flags, unsigned long pgoff, unsigned long *populate,
+	struct list_head *uf, struct mm_struct *mm);
+static inline unsigned long do_mmap(struct file *file, unsigned long addr,
+	unsigned long len, unsigned long prot, unsigned long flags,
+	vm_flags_t vm_flags, unsigned long pgoff, unsigned long *populate,
+	struct list_head *uf)
+{
+	return __do_mmap(file, addr, len, prot, flags, vm_flags, pgoff,
+			 populate, uf, current->mm);
+}
+#else
 extern unsigned long do_mmap(struct file *file, unsigned long addr,
 	unsigned long len, unsigned long prot, unsigned long flags,
 	vm_flags_t vm_flags, unsigned long pgoff, unsigned long *populate,
 	struct list_head *uf);
+#endif
+
 extern int do_vmi_munmap(struct vma_iterator *vmi, struct mm_struct *mm,
 			 unsigned long start, size_t len, struct list_head *uf,
 			 bool unlock);
diff --git a/mm/mmap.c b/mm/mmap.c
index 7a057e0e8da9..18f266a511e2 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -275,7 +275,7 @@ static inline bool file_mmap_ok(struct file *file, struct inode *inode,
 }
 
 /**
- * do_mmap() - Perform a userland memory mapping into the current process
+ * __do_mmap() - Perform a userland memory mapping into the current process
  * address space of length @len with protection bits @prot, mmap flags @flags
  * (from which VMA flags will be inferred), and any additional VMA flags to
  * apply @vm_flags. If this is a file-backed mapping then the file is specified
@@ -327,17 +327,17 @@ static inline bool file_mmap_ok(struct file *file, struct inode *inode,
  * @uf: An optional pointer to a list head to track userfaultfd unmap events
  * should unmapping events arise. If provided, it is up to the caller to manage
  * this.
+ * @mm: The mm_struct
  *
  * Returns: Either an error, or the address at which the requested mapping has
  * been performed.
  */
-unsigned long do_mmap(struct file *file, unsigned long addr,
+unsigned long __do_mmap(struct file *file, unsigned long addr,
 			unsigned long len, unsigned long prot,
 			unsigned long flags, vm_flags_t vm_flags,
 			unsigned long pgoff, unsigned long *populate,
-			struct list_head *uf)
+			struct list_head *uf, struct mm_struct *mm)
 {
-	struct mm_struct *mm = current->mm;
 	int pkey = 0;
 
 	*populate = 0;
@@ -555,7 +555,7 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 			vm_flags |= VM_NORESERVE;
 	}
 
-	addr = mmap_region(file, addr, len, vm_flags, pgoff, uf);
+	addr = mmap_region(file, addr, len, vm_flags, pgoff, uf, mm);
 	if (!IS_ERR_VALUE(addr) &&
 	    ((vm_flags & VM_LOCKED) ||
 	     (flags & (MAP_POPULATE | MAP_NONBLOCK)) == MAP_POPULATE))
diff --git a/mm/vma.c b/mm/vma.c
index 3b12c7579831..a7fbd339d259 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2637,9 +2637,8 @@ static bool can_set_ksm_flags_early(struct mmap_state *map)
 
 static unsigned long __mmap_region(struct file *file, unsigned long addr,
 		unsigned long len, vm_flags_t vm_flags, unsigned long pgoff,
-		struct list_head *uf)
+		struct list_head *uf, struct mm_struct *mm)
 {
-	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma = NULL;
 	int error;
 	bool have_mmap_prepare = file && file->f_op->mmap_prepare;
@@ -2706,18 +2705,19 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
  * the virtual page offset in memory of the anonymous mapping.
  * @uf: Optionally, a pointer to a list head used for tracking userfaultfd unmap
  * events.
+ * @mm: The mm struct
  *
  * Returns: Either an error, or the address at which the requested mapping has
  * been performed.
  */
 unsigned long mmap_region(struct file *file, unsigned long addr,
 			  unsigned long len, vm_flags_t vm_flags, unsigned long pgoff,
-			  struct list_head *uf)
+			  struct list_head *uf, struct mm_struct *mm)
 {
 	unsigned long ret;
 	bool writable_file_mapping = false;
 
-	mmap_assert_write_locked(current->mm);
+	mmap_assert_write_locked(mm);
 
 	/* Check to see if MDWE is applicable. */
 	if (map_deny_write_exec(vm_flags, vm_flags))
@@ -2736,13 +2736,13 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 		writable_file_mapping = true;
 	}
 
-	ret = __mmap_region(file, addr, len, vm_flags, pgoff, uf);
+	ret = __mmap_region(file, addr, len, vm_flags, pgoff, uf, mm);
 
 	/* Clear our write mapping regardless of error. */
 	if (writable_file_mapping)
 		mapping_unmap_writable(file->f_mapping);
 
-	validate_mm(current->mm);
+	validate_mm(mm);
 	return ret;
 }
 
diff --git a/mm/vma.h b/mm/vma.h
index bcdc261c5b15..20fc1c2a32fd 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -352,7 +352,7 @@ void mm_drop_all_locks(struct mm_struct *mm);
 
 unsigned long mmap_region(struct file *file, unsigned long addr,
 		unsigned long len, vm_flags_t vm_flags, unsigned long pgoff,
-		struct list_head *uf);
+		struct list_head *uf, struct mm_struct *mm);
 
 int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *brkvma,
 		 unsigned long addr, unsigned long request, unsigned long flags);
-- 
2.47.1


