Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B65AECA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 13:11:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0135F28001C; Fri, 22 Aug 2025 09:11:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDEFC8E009D; Fri, 22 Aug 2025 09:11:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF44F28001C; Fri, 22 Aug 2025 09:11:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C5BAB8E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:11:29 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7B4D8136CDE
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:11:29 +0000 (UTC)
X-FDA: 83804429898.28.D6B3130
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id C8F94C0014
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:11:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=NVWwwP6l;
	spf=pass (imf28.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755868287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=TFfw2XIDiNSUM2peVfbbJOiySrYb+k9quvNiTrqtO2A=;
	b=noBx5soeRMILk4DdbCmFTMTe62j25nsRE91kTUpyhudjDNgqNBuYW/rODvTvaMN5K8cHPN
	N3Ec+MWDnJJEzVjDdAcaMO7cXZyCiYxpJ8JHgt0MOmQdAUPO5/tendNYhLXnlh7rhZH00o
	pTXIRFmKemOGfkcUacotseojtT8UD+w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755868287; a=rsa-sha256;
	cv=none;
	b=K1IM+w68rymdCvQqfVooy3r9jSpB3BD5VdkQvys4GPhZhP0r8Ge0LNEU4iVQWuEz+ii2Vs
	X7feMZqYT4EIVK2LaMFVnp2tKjrSN2Jm9yFoURBkuYkMSZVrFYAnJkxYPsOW3RSzAyF3L9
	5YTwSo1da/glE+KaRKxKnyK6cyULZkU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=NVWwwP6l;
	spf=pass (imf28.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5530560266;
	Fri, 22 Aug 2025 13:11:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF65C4CEED;
	Fri, 22 Aug 2025 13:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755868287;
	bh=xag2mnhF5V9FSJUl0cBF+BouNwLZgZt3NVunwS3cdLA=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=NVWwwP6lFW2lPi5PuSiJHt9j+fgAzZsVoWi4yjVITIVBSg57g+ds9bdhHwbSgxATA
	 hXToQl0w4ccFz0cHztUrbFcVs0LQwvrPj6hO/KkLihqhsfZsJdxbZTL2/UC6EsPD2v
	 +PRAfKAw9gXvgwmYZf+yLXlktJO+n7yf7b2+nC8Q=
Subject: Patch "mm: update memfd seal write check to include F_SEAL_WRITE" has been added to the 6.1-stable tree
To: Liam.Howlett@oracle.com,akpm@linux-foundation.org,aliceryhl@google.com,baolin.wang@linux.alibaba.com,brauner@kernel.org,david@redhat.com,gregkh@linuxfoundation.org,hughd@google.com,isaacmanjarres@google.com,jack@suse.cz,kernel-team@android.com,linux-mm@kvack.org,lorenzo.stoakes@oracle.com,lstoakes@gmail.com,luto@kernel.org,mhocko@suse.com,mike.kravetz@oracle.com,muchun.song@linux.dev,osalvador@suse.de,rppt@kernel.org,surenb@google.com,vbabka@suse.cz,viro@zeniv.linux.org.uk,willy@infradead.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 22 Aug 2025 15:11:05 +0200
In-Reply-To: <20250730015247.30827-3-isaacmanjarres@google.com>
Message-ID: <2025082205-petty-thermos-fbf5@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C8F94C0014
X-Stat-Signature: u6a4otbhdzx157c5hued1o44d9zx6od5
X-HE-Tag: 1755868287-10803
X-HE-Meta: U2FsdGVkX1+Uom7obo/RwDcAlDa/CyShNYfz2aYgngKu2A+3HY1dfeGexunOKlXFHo2x+kdbBXIDNgMYjUg81Z7jtHHl5eM/iF5yDkx7AJOpg+pnrhJKIUQegCmglWfodi97GOS0Z1vSJ1CjSzJPJ2JmF6ydV3OwWvsPjB4raTfxRT3yr+HrgDbXTA/450ol+D5F2p3RHerPt7W1AeS6hq7weG8BXo/ggJn0yij5EomsOnUC3Lm1bvk126xwdaosoS649+nGYv75P3WeDm75a2uEMZiNrPlOSCCVfAmedubrNX4XEXKc29B7lFeigsbh+pw6BXn2xXgYL9vPJHEYxwqQF4ydeecsFibT967cfxM4vDRbgdofiKola6djzMlrtMQQSdKHbjx+qu+u5S1N0HrvHjTtJQ+Ew+d5mhXTKRRgWRnu3UfCut4ABeXcyg+jJcSd/dbDUTBj17Nq8uvOikyx+Gv5hBqSznlOEGd5Zse/VwjnGCNoN1392buYFyZWKlKqW6iY/PhREJe24Dl78ki3oWIJOKWPtk8PtNEWheALrHLKq21fL+xwTp1HsgEpVvuhMF+cS5svrdjHYnQTwjPanAfPa4cPZidkag1YZGRY/bE5OkjJAP/qW6mjvR2yk97Vgwv8WtAv0dqxgyNO3rtya36jpLs/1wf+I6mAupOAp3kasgxvbxPnKxTg+E04i8rWw28rX3lNSFOYLgZe/tda/FLZJtxFuCUwrWdVHhy3gNzqIQ2YfMaRNNopBj8HoBxh72YRBG3/DUAfB+xyhgZ1wARuhaVBJx4reyyZVMDAlJZFRSPSqlRjprgtbtIeXnXu/mmTFOmoL8Hdz/IUbtqnPsUElwHmI7Ue3d3+XDzgmujRdWiDQs2+7bfdRvCrxlRONxg0MIwCos3b3KNdrEQYxptQcjtBXp+QCy4D37KFHrdpfiEQHW3yRZSPDQqwTiz6e0Fuv+Flz536sl8
 Zlxv8ouo
 9djPkCTnWKz7s10pjpVGoTauZX4jYMZqPMmLi/UmfJpnF+zTAsU0XXm/WBjFxzPEFuoN69RJoGEL21Uqc17pUFqFHKf1sTG8hyvBrkcqj77iG5JZS8vOI4K6nxm83C6EgfoWwJtjt1QTQQ7d1mrpfZiMRH8lfeNH/Z/geCg/bP7RWnSRz7g13sueh23Q23pZ7YwVIqJH9SXtiOJ7M/MfLtco+pMbBkx0FBdBzhmvajWUp2tHoeMIm5HbbDFxZ6kNAkJZjKGm4pDZNAAeKBTo1F9+3iaVPbhUgRvy4++6Ao8NiAtHoYpa9nyAotb3aYvZcC52GzbADiP7RYFc7C9P+6gBmEPWflei2KTFmqzmgGxD/UHPglifQYIsFgCJBrjkZVNleKWTdVbE8pY96fPbtNADwiiTNxLQnxdXuGMQAtpwJUrcFHIXN6bj3oiuSZEIe9aIYrPpHFo3H1NXAzWlRTBojh4SmdUy6JIZmoCgZNhpWxlFN+/WPldPDCH1C9Lv8xT6Sdb6mbzkrEswo7oEpH+bMmp11DBUeI6+sXyXUvauniie0nJrl9J8mmbrSEXaQgLcDZF/FCsjyTRGrIrl+V9Rp3tEpkIqyq5S6AnysyZRiJY2lufEHqWx3QLeft3yen4r/nOAzvjHLvC+2mv96GqsahqnYhYcPWjoWp2JNKFPuNmpeM9wKfCpKVBWqGl6S6NwW1fZIKm38yfGHO7msnDoO9+6IAMy34nS65Y+h7D6+bjSHcs5Mg8fNk2sXwuu1Rb0D7wC48yBXyYl3MGXq+Met9mmxISjJVkrGiQS6GmwLWpj4EHJlIO70gn+8+diQNQCvRXeLRulIH+dwDJY7bvRTKDtC08i+AAxyx3NQQHhQDy6u3WJnX7VbynYbwbc8jXZQFNB5K7fXaF1AL5MdF4YVTMusOKaCZ3GITMaiBmSWxrD5BTs2+AgvEfpkPm8JxXxA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm: update memfd seal write check to include F_SEAL_WRITE

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-update-memfd-seal-write-check-to-include-f_seal_write.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-165165-greg=kroah.com@vger.kernel.org Wed Jul 30 03:53:44 2025
From: "Isaac J. Manjarres" <isaacmanjarres@google.com>
Date: Tue, 29 Jul 2025 18:52:41 -0700
Subject: mm: update memfd seal write check to include F_SEAL_WRITE
To: lorenzo.stoakes@oracle.com, gregkh@linuxfoundation.org,  Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,  David Hildenbrand <david@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,  "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>,  Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,  Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: aliceryhl@google.com, stable@vger.kernel.org,  "Isaac J. Manjarres" <isaacmanjarres@google.com>, kernel-team@android.com,  Lorenzo Stoakes <lstoakes@gmail.com>, Jan Kara <jack@suse.cz>,  Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>,  Christian Brauner <brauner@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,  Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Message-ID: <20250730015247.30827-3-isaacmanjarres@google.com>

From: Lorenzo Stoakes <lstoakes@gmail.com>

[ Upstream commit 28464bbb2ddc199433383994bcb9600c8034afa1 ]

The seal_check_future_write() function is called by shmem_mmap() or
hugetlbfs_file_mmap() to disallow any future writable mappings of an memfd
sealed this way.

The F_SEAL_WRITE flag is not checked here, as that is handled via the
mapping->i_mmap_writable mechanism and so any attempt at a mapping would
fail before this could be run.

However we intend to change this, meaning this check can be performed for
F_SEAL_WRITE mappings also.

The logic here is equally applicable to both flags, so update this
function to accommodate both and rename it accordingly.

Link: https://lkml.kernel.org/r/913628168ce6cce77df7d13a63970bae06a526e0.1697116581.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/hugetlbfs/inode.c |    2 +-
 include/linux/mm.h   |   15 ++++++++-------
 mm/shmem.c           |    2 +-
 3 files changed, 10 insertions(+), 9 deletions(-)

--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -136,7 +136,7 @@ static int hugetlbfs_file_mmap(struct fi
 	vma->vm_flags |= VM_HUGETLB | VM_DONTEXPAND;
 	vma->vm_ops = &hugetlb_vm_ops;
 
-	ret = seal_check_future_write(info->seals, vma);
+	ret = seal_check_write(info->seals, vma);
 	if (ret)
 		return ret;
 
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3526,25 +3526,26 @@ static inline void mem_dump_obj(void *ob
 #endif
 
 /**
- * seal_check_future_write - Check for F_SEAL_FUTURE_WRITE flag and handle it
+ * seal_check_write - Check for F_SEAL_WRITE or F_SEAL_FUTURE_WRITE flags and
+ *                    handle them.
  * @seals: the seals to check
  * @vma: the vma to operate on
  *
- * Check whether F_SEAL_FUTURE_WRITE is set; if so, do proper check/handling on
- * the vma flags.  Return 0 if check pass, or <0 for errors.
+ * Check whether F_SEAL_WRITE or F_SEAL_FUTURE_WRITE are set; if so, do proper
+ * check/handling on the vma flags.  Return 0 if check pass, or <0 for errors.
  */
-static inline int seal_check_future_write(int seals, struct vm_area_struct *vma)
+static inline int seal_check_write(int seals, struct vm_area_struct *vma)
 {
-	if (seals & F_SEAL_FUTURE_WRITE) {
+	if (seals & (F_SEAL_WRITE | F_SEAL_FUTURE_WRITE)) {
 		/*
 		 * New PROT_WRITE and MAP_SHARED mmaps are not allowed when
-		 * "future write" seal active.
+		 * write seals are active.
 		 */
 		if ((vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_WRITE))
 			return -EPERM;
 
 		/*
-		 * Since an F_SEAL_FUTURE_WRITE sealed memfd can be mapped as
+		 * Since an F_SEAL_[FUTURE_]WRITE sealed memfd can be mapped as
 		 * MAP_SHARED and read-only, take care to not allow mprotect to
 		 * revert protections on such mappings. Do this only for shared
 		 * mappings. For private mappings, don't need to mask
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2302,7 +2302,7 @@ static int shmem_mmap(struct file *file,
 	struct shmem_inode_info *info = SHMEM_I(file_inode(file));
 	int ret;
 
-	ret = seal_check_future_write(info->seals, vma);
+	ret = seal_check_write(info->seals, vma);
 	if (ret)
 		return ret;
 


Patches currently in stable-queue which might be from isaacmanjarres@google.com are

queue-6.1/mm-update-memfd-seal-write-check-to-include-f_seal_write.patch
queue-6.1/selftests-memfd-add-test-for-mapping-write-sealed-memfd-read-only.patch
queue-6.1/mm-reinstate-ability-to-map-write-sealed-memfd-mappings-read-only.patch
queue-6.1/mm-drop-the-assumption-that-vm_shared-always-implies-writable.patch

