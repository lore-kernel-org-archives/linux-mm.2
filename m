Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD186CD98F0
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:34:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 127B66B00C4; Thu, 18 Jun 2026 20:32:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FE536B0088; Thu, 18 Jun 2026 20:32:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE0FB6B00C5; Thu, 18 Jun 2026 20:32:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B37006B00C2
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:32:12 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3A9BD1C16C0
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:32:12 +0000 (UTC)
X-FDA: 84894785304.20.BEFBD6E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 47CF44000A
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:32:10 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="q80Wbh/X";
	spf=pass (imf01.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829130;
	b=zZv53i13DLMmBaXzPIRgHEpLXOZV9CZUBZvot1VcRZWHTndrb6mIpWPQKsnSVmMTWNTfxM
	mIObQuSGYeECEf0t1mTMSt3LY+mn8iSyXyNr5DXh9HbXoBJBbcQhylwRZhhxvpI0oPEoXe
	wQNL1EEDiaB39OZfJUY3VB82lpvayOI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="q80Wbh/X";
	spf=pass (imf01.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829130;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dQAx1lf/q/UJ2T+ZF4VPC49HYHDboPh+hFmtLzlXKZ4=;
	b=g04fHD0sz+kHU6gezEFIQw0vcVGyVQFHiJypW/KmHIiStE633Sgu0oEnFXwlGBQxffRVYd
	FONvtOlHJ/tfSODrBpfRcxUU+kfrQpnBSNY6nVRZZA3CNsjZdjOFR5uYkIIJjkQgUD0fEP
	YYHo/nkHfCZ8sHq+i44klGKI/EUZnWU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 84BD944E64;
	Fri, 19 Jun 2026 00:31:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 39991C4DDE5;
	Fri, 19 Jun 2026 00:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829111;
	bh=N7rSu4GBVvvF+mRKIbced645XzNRnFAZny3SraOu/Lo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=q80Wbh/XNAbH4XasX/d3S9uguNh3fQF/m5o1fLy6JRIKCKOJqAIjTjwuHTz/pwpYc
	 //M7Lm0lLZjDoEKZaCalXZp/arAkw+2yCsa+TwVUcAfW1xczsw93DgorZgxKbBvm2B
	 DAUBkTf4s6Q4I2vHVWXS2QBJz1XPvYoow2csFuSLlXoTAJabtmuXv/U2PwVhk5n4Lt
	 QkNK/ROrbVAyLNFbl6vrHASuxnTamuwiELBysgEX15x72An3Wfx35GNfYOgYCbbV18
	 OexjYJ9QNFK5eVneI2OCH84dJTPHfN2N/JLKMBMPmzBUGEnR/Iq8/44vTx6ZFZChw5
	 wHX+jgKIKCJIA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2814CCDB467;
	Fri, 19 Jun 2026 00:31:51 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 18 Jun 2026 17:32:20 -0700
Subject: [PATCH v8 43/46] KVM: selftests: Check fd/flags provided to mmap()
 when setting up memslot
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-gmem-inplace-conversion-v8-43-9d2959357853@google.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, tabba@google.com, willy@infradead.org, 
 wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
 pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=1300;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=FfvOOziuKY7J+zAwvdCM21a/oE41ilanjqOldELME0Y=;
 b=bGm6mj4nU3DmKRVpn7tZlCQEkarM+48B/RQBAyw/VTpU0D3j33YT8OwpwMm+dDQJ0LUtFNveM
 KST7dvTTwduBD/4p9kp1IKhL8gRzKBkk40HX2bYJ916lTYy+dF1md+x
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: wa9h317r67xpptbhocwsa5fdhq5xy7wj
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 47CF44000A
X-HE-Tag: 1781829130-472467
X-HE-Meta: U2FsdGVkX1/ndSBkX6W8SHPlXGw3q1jeJMTIxNVrj/6SsJSmhWTVygM9DlpaZ20fvBVhqkbi0eobmMOJmLVl+o+jjlwxCLuJmyY5vp6/JRGxhNE7P8nFOMXQkJNT08MEBgztIzh6Jm+ZBinGOAuwZzUqHweBPu6jmDh/wr4MUDYrrVskX2/rhBnHRIx1peKgj+fFsXF5QiFaAUwwEGO0UvtuRtCODmRo0EZXxvnxb4ZsGyMCZkZlIBzDqdZ8ZZ+vIaIRAncxV2UNDZGKtnKkJaOKtoJps3WgIqF26BldDAvwCEfYnncGUDdC6CBMW7QQt0R9UXMJyiRzlvcKGN+BGxdQGgwYE0yQLvrLIGAwF01AjeUyhkQguz36aOMPXNnY41lU0O3vyfr0ZPekGprjCntxhBSe62nhi+K3WZ09vp11rgM100Jk1sdH9f+6EmLOgLs1kJek1F1gMsMeZsPhfVvGE9O68EJykk7y/vASetxno71o6vVUq+LPzDJITo1KkXB8jVlnuA0YwnDJvLCmd1yW5zqx7hNStTmCRdqkrVltozdrK2E/7LYW7phjjEXQyxiRxLv0BWIYgHhX9nn5GqgTUqzlWyhryop64F/+yH1CeJnR1OuhE0dlThm9LhBTjiS6A63trboul/DmVAeVzi5bIDo+XPVCNxEaJvHzP0b0iFVt8Zm6z9hymgqFPUvIekiNJYSsMqNBwueEYqFN+UMjjfM3FcnwNarZRBq7c36MG1N0wwTovUadq3ftuiSeg9cQyQwQL4Al8NNHXqm7n3eBL03dMf/ug2b02+P0yROcKNib8s3RgndFRQwUVQmmr/g6UDzsJZpymCHrL4nlV7YSu7Skn27G/UtLjxt85rbHqZrmv7swM37PFi/+Wli2e/b+O/CAxWPx9XTGggNT8Qx97i7+7jsTeOzMKp6AY/SQ3F7D6ly3LRhM0Pdd9RwUVhkzAap9XZvTbcE6F/W
 jXAHpJDm
 vbLk9cyX6P+hZWeWTLVqSiL9pHWBv83jMl6cocSv40ssG1RtokpvKlLjcP96zlaFQ3poLP00MoirDlw+pCpe16fAV/zJbg4VXJS9Tb/Z8D/oT03zCXxfmVowNj0BDVhZ152n7vHGLuusxe/MIzouj9LCdtvJM2VjFHXZ4mffbnauUT+9vg3cGQ9+PCpLnm0Mq3jYpTb6xB1ybQTEHNIcbi0IP74/LUP1kKLTvxmbaU7Si8E7SDiZ3U19WdEn085SfblD7icaXbcDgbueXLl+g4OKjY6EzqvVaDnQzSmBJp2FE5zsdL6MPvvqFrQPAyyLUnWhk9IfSy165hSJnE0RULQpY+jjRn7hxokFv023Kd9HYTm0losbLcrE8rDIO09Yw6I9PhD52X1TcxVm33gnl/GIKHBD5QBiBrzyAPuUR1VczG92nIDFnLjKhFghOCO8bx+Wcm6xGdP08s3I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Check that a valid fd provided to mmap() must be accompanied by MAP_SHARED.

With an invalid fd (usually used for anonymous mappings), there are no
constraints on mmap() flags.

Add this check to make sure that when a guest_memfd is used as region->fd,
the flag provided to mmap() will include MAP_SHARED.

Signed-off-by: Sean Christopherson <seanjc@google.com>
[Rephrase assertion message.]
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 0b2256ea65ff9..6b304e8a0e0d5 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1110,6 +1110,9 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 					     src_type == VM_MEM_SRC_SHARED_HUGETLB);
 	}
 
+	TEST_ASSERT(region->fd == -1 || backing_src_is_shared(src_type),
+		    "A valid fd provided to mmap() must be accompanied by MAP_SHARED.");
+
 	region->mmap_start = __kvm_mmap(region->mmap_size, PROT_READ | PROT_WRITE,
 					vm_mem_backing_src_alias(src_type)->flag,
 					region->fd, mmap_offset);

-- 
2.55.0.rc0.738.g0c8ab3ebcc-goog



