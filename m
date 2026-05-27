Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 760C1CD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 18:48:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD8C86B0092; Wed, 27 May 2026 14:48:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C62A66B0093; Wed, 27 May 2026 14:48:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADD0F6B0095; Wed, 27 May 2026 14:48:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D6D26B0092
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:48:10 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6EC911C0519
	for <linux-mm@kvack.org>; Wed, 27 May 2026 18:48:10 +0000 (UTC)
X-FDA: 84814084740.16.DCADD42
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id C076F14000E
	for <linux-mm@kvack.org>; Wed, 27 May 2026 18:48:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MydiH42z;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779907688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=07ezutEcInVG//yT0ldXpRUrdrAzNSr842HzE2J9pPU=;
	b=YJmIPiC/ApQkgRfWk+J8tZL3uUTSHZ7/oKFu4WWiKqS35sDlqqHhJ77wjrUzLaMpd2YOKr
	+d1OhX79I5L8WZluhlvWvezJ0FVv6UVBPCO9dLcJgnMJueCS8h7q+KfUhsaXfv5uvxcHZJ
	QMRIxUARCG5wRqQ4z5U90r0rDwFFu8A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779907688; a=rsa-sha256;
	cv=none;
	b=6yNxna1oWeMq7R36LdxcEPnIIy6CdxnaQiiWfROEHptdTMtHDe1rJUNM0OIsXY9H7FWp9n
	Il/pQ4Lko4cdtiAq/YaX0IQEF6LWopyg1t4jaPHfFm+TnPctSAySC2aR4pDorQbLVzpsxY
	BUP7BQrvwwF+zEJQUpTuClL+zoQhNeE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MydiH42z;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E14D14028E;
	Wed, 27 May 2026 18:48:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 200E11F00A3D;
	Wed, 27 May 2026 18:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779907687;
	bh=07ezutEcInVG//yT0ldXpRUrdrAzNSr842HzE2J9pPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MydiH42zD2bX1JV7tCa3KUOOt4FutOpXpMqIykH5OrWBjIlX80mFOaFz/iCyq89Dy
	 p6Tp8luXT72Tq+Km8mCwL0b/DxrsAtIknnypO8kh666+qL7Tv5vV6UGlyN9+X9haaw
	 Oy5/1x+wWonkUSdl2+dHuSjyBWDDvc6PrZm456vfAUhXs2Dcr+VNM8J5memLbt94+O
	 9Wr97k8aBGuueLEyI8SLfiAo79l49ah9ioUQyYmNLBOjAw6Ff+12JSHR9HQbsZdajC
	 fk5PtvmP3vYKzub50UpAcyCQT52xTt4TPJ0R70irEgsu6Vtv7pMrd5oSj22Gc9vFD9
	 eqLQsHv1g22WQ==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Carlier <devnexen@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Heechan Kang <gganji11@naver.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] userfaultfd: remove redundant check in vm_uffd_ops()
Date: Wed, 27 May 2026 21:47:51 +0300
Message-ID: <20260527184751.4147364-4-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260527184751.4147364-1-rppt@kernel.org>
References: <20260527184751.4147364-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: n9uo57kwbweuzfh9s4ef89dmaresmx5j
X-Rspamd-Queue-Id: C076F14000E
X-Rspam-User: 
X-HE-Tag: 1779907688-833715
X-HE-Meta: U2FsdGVkX1/TcnInK7ZY4XdqHKGQxc0ZOaqK27HFZpuxqGvfrxFSKcHo6xSjiqx7SJXZATw30eIiq0ZinJ8Fp+8mk4ClkPYASng/gW0FT2G1yQjDu1LjKAbPync9m61LHVFsVHmwDy5ljgm+e1gLBTdLdi3yOG1BU8qqZNB9utAkvsHEXoEJrFjfbwMYXiGjtd1HxdMa9IeCc9RPwX8ehGs2uz2k8S5nmfpo/1boCZjdE2JNhAmV7wrMiXuU4gxxJ8XTvUjLB5NBXCJpA6VIfqUuTYsjuH8huR1/FRKIsLA2eiMIZA1nIToZ2AmDvqANx+jcE+nwf1EpEsGoe3uUdENW734gJUJhU3OGeeu9lQH3ur27tUMtuuZlHGkvhlSChOehRLs003CT7wAY7el9MwC0vV9FNto88hkUAS78x0NL4flslTqnRoxoQ0GNUPYQnkFC0kuI1shi66pw/3VvIaaALKMAKHMqiCeQ/ABNRvml1go2WjDsa3qbBWgvqsN0F/ldrsx86RAA/g5ZVb+oLnC5qGI1NN1INoWJAmSklaCQyN5migQGQWu7+IHQjzgsbIQhPPH9ndNkqe85L2xDETcO+5BSg24li1rvka5eki8wAW/S+ho7ztrTyXF8cjaaAFwKnB/aNMYIAkpw5X2mtvnTqiMxCzhacBuAClLlgKkNkhYvps/o8fR5QrRD8b5IKdIvOSxWOMIQEewnR2S/4djN7B6sKedvvUVSAEp/QyoJTJbait9GSwaE2egUgojSHRxmJXwyskFiIO2UExOmIUY211Mzo33IwmbrF0QfCcF+uJztHNOncwjbmOOmtqwHqPTcbt27lIKxe8b8IgFYKH/EiludpLtNbEnIBVaHdPpsUEEAiY6u0XV5vECWwo8lIK1beswW47sV1mYiloKsDVuRQWhAQdO0+Xoqt7kfs6R+Ku9qCy/u4LQjLDdmTx34hjLzIo457dsnHxT+GzX
 +IPW+IyR
 UTyD8NNywKcnQOuxwh1NGfEU9tv2IyIV+xix1SOc2B575JagtBB7/GI7rZ/sHxFCiqjS616RrjR9FS7mHJ6VMCpgq12SUfVx5EsPJT4RjIJe6duItevkk2V+y6gWw0DXtYDdIzbQTTSBD46BQWyv8a4DUEeY9KW+9dSi2d7BzSEKqoPNp6xG4paMmOb8w+1TIUVOY5SFonlwV2iP3OzDM/eDMY3O4CyNc0mUllqpOFcPT5l2M7/4eb2HQ13EiHvAq74uvnV/Ry6bMIuZohtvm27ylTYveXnW7y4mXbiIiK6jH4Yh854CJcgWYsmpJgZvMJT7NfzLoXTcKr7T4caqFDq+Ab8a1+uNtPZQO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Lorenzo says:

  static const struct vm_uffd_ops *vma_uffd_ops(struct vm_area_struct *vma)
  {
          if (vma_is_anonymous(vma))
                  return &anon_uffd_ops;
          return vma->vm_ops ? vma->vm_ops->uffd_ops : NULL;
  }

  This is doing a redundant check _and_ making life confusing, as if
  !vma->vm_ops is a condition that can be reached there, it can't, as
  vma_is_anonymous() is literally a !vma->vm_ops check :)

Remove the redundant check.

Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
Fixes: 0f48947c4232 ("userfaultfd: introduce vm_uffd_ops")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/userfaultfd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 2872c71bbf36..80cc8be5725f 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -68,7 +68,7 @@ static const struct vm_uffd_ops *vma_uffd_ops(struct vm_area_struct *vma)
 {
 	if (vma_is_anonymous(vma))
 		return &anon_uffd_ops;
-	return vma->vm_ops ? vma->vm_ops->uffd_ops : NULL;
+	return vma->vm_ops->uffd_ops;
 }
 
 static __always_inline
-- 
2.53.0


