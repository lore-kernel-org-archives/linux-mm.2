Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA62CCAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 03:37:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA6168E0001; Tue, 16 Sep 2025 23:37:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E37258E0011; Tue, 16 Sep 2025 23:37:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF2E88E0001; Tue, 16 Sep 2025 23:37:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C7738E000F
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 23:37:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 543F5B7C85
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 03:37:47 +0000 (UTC)
X-FDA: 83897332974.01.FD04557
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	by imf23.hostedemail.com (Postfix) with ESMTP id 035B7140005
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 03:37:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.81 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758080265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oCaOgn/VUnUJcxJCdCk7imxJ7IQSc9PijQemvUC6Up0=;
	b=7xsm3/GTz7xW9tpnrwYgD1X3NTr0SU8sw1R6Imph1QNzP3ceC8AfODbIlTHY/so8j0LjBm
	+JcUjuT4xDE/S+gW5NOsqpf4LYm8GKy2Hq6M7UjU+KQSw2ltufy/0E1e0T20iV8W2cCkJI
	4PKTgASfBMxIdiqT0KEYEFoMY9Jg34Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758080265; a=rsa-sha256;
	cv=none;
	b=KP/3ZqUOzsOc98re+X2FYAZ8iDxSLyLONy0ro7Q6b5G9J5CtToaLlvRtXsUKUr6PuZCHJC
	83JZC5254x4TCqpykVzn7MtpRjkX1QY9+MBrB8l14qppejrKGvfGP8cjK6FrmL5Cpt6ccE
	uHzcMQS3FvNRmv02/YmwXOMlfhut2to=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.81 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn;
	dmarc=none
Received: from ubt.. (unknown [210.73.43.101])
	by APP-03 (Coremail) with SMTP id rQCowABnsXvsLMpojtxAAw--.607S8;
	Wed, 17 Sep 2025 11:37:33 +0800 (CST)
From: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
To: linux-riscv@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Conor Dooley <conor@kernel.org>,
	Deepak Gupta <debug@rivosinc.com>,
	Ved Shanbhogue <ved@rivosinc.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Xu <peterx@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Chunyan Zhang <zhang.lyra@gmail.com>
Subject: [PATCH V13 6/6] dt-bindings: riscv: Add Svrsw60t59b extension description
Date: Wed, 17 Sep 2025 11:37:03 +0800
Message-Id: <20250917033703.1695933-7-zhangchunyan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250917033703.1695933-1-zhangchunyan@iscas.ac.cn>
References: <20250917033703.1695933-1-zhangchunyan@iscas.ac.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowABnsXvsLMpojtxAAw--.607S8
X-Coremail-Antispam: 1UD129KBjvdXoWrZr1xtry3AFykZFyktFy7KFg_yoWkGrX_Ja
	n7Za1kZ3yUtFnYqF4qyr48Kry5AwsakrWkCasxtF4vka4UuFZ8tF9rt345Ar17ur4fu3Za
	kFn7XrW3trnrWjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbP8YjsxI4VWxJwAYFVCjjxCrM7AC8VAFwI0_Wr0E3s1l1xkIjI8I
	6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7
	IE14v26r126s0DM28IrcIa0xkI8VCY1x0267AKxVW5JVCq3wA2ocxC64kIII0Yj41l84x0
	c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2
	IY6xkF7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E
	87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64
	kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm
	72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI
	1lc7CjxVAaw2AFwI0_GFv_Wrylc2xSY4AK67AK6r48MxAIw28IcxkI7VAKI48JMxC20s02
	6xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_Jr
	I_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v2
	6r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcI
	k0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4U
	JVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7IUnoSotUUUUU==
X-Originating-IP: [210.73.43.101]
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiDAUIB2jJ8PfwdgAAsm
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 035B7140005
X-Stat-Signature: qkyok9p5mhmfhr6m3q55nxj1hyj1ga1x
X-Rspam-User: 
X-HE-Tag: 1758080264-108353
X-HE-Meta: U2FsdGVkX1+uKF/kEx2ozZthn2C0k/Apc10VC5RgfEPXCZ+3OpH+UnsGoJ4Jb8E9Z4l57P5MjeX9TWmKSelgPk0X0NBPjdwSL5Z9MKYSAZSWMEA4wzf4swjKSHHEfd4+hT9H1gSEw05DF2uFLoqg568gMVip4wX0GYvoaqMC5A0x/2jrbmXmDG9WVdSIvYIhUAKmDuxkOyBuUetAUIbOBJUuyWQjAYFzbSVMaIbIuxbJLf1kDwQwSO5f/oHRDkDVq2f0p9AUbUCBKHAIwBjIP7g9LCYYS61gfimW5Pe15RvIEBqOB34Tkde5AttYLvcE3PeCtjSvds7KO4gPVf60v3/U4QXBPtaZCUdurQ2HvEL6Ime2sxnNMrr6Ro1bw9T2jMewovyJD0fVfd714XZBneBffqROmNtuaYTjoQGwtZjamhOl9BK0IllE3OyndrPit7iI5l/hM76Tueg9ALFGtEZFDS1hJ1fV1GmQ/zKtA7HFTYCRvgKp9YcO0n+rKeHUXGZjOsxS5sYHjewWk5kBNiHMIzd5Wod44L7c4sGlfAGWPTQqIVshUC+XgTdTmZzGMc4PqiMJGd0RjEy9gUxgl5y0yaBBw6nFCF2GkKQwBkVjQb37m/Jrjf+94Vl+/Q18ijnMM55NWV3e1m1qRVr1p5Jkpa63fw/6p9giKszhKDO0leNRNDqL31/5aeus97LKh0yJp7/ncg2uOyM1ZN4t1OpKTaukw8kvUeU1eNhcNr6FA2DA4gXK5JHSr7YboXPWg5wjhPj+fFnnH4nDEAmRfIKBYGm06Hal9l3suluHpjiM51DLiBnVIMurceQpJ1ZodkFXrV4IXoETYTU+nxUR8qNC6B3Cap+ImbGvCJwMlaJoa9ps2I+hNclP+ZcJC2A7IRwM316AHAxYuDDy+6CBfQsuigVtSCofMOBVCsqzheNi75VQPpQ551qBmWh6mXokV9I90rmSX/Yn9WQLh3Y
 xLPLzvae
 YI9gyDR7ucQdjj1M3sdcMCljC4FDB1FdT3k+HZ+NUgwu7Eqiz+Pv3D+u6YRVAtClleB7pLVlbNehM+wLSyhODEBFspjxQlUSvy94U6ntZUwRG9Q4gKbXRxx79iijrfvozCNPXuOYVE38YOxbdbboO2p7/ygVVkM6hz+BbhwqauvIwqZl34+89auHsLMhJq6gU0iIpkx3GxTcbx++N8MmCZ9MnYQIfsGEtqDemFvJ3s5aA3xI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add description for the Svrsw60t59b extension (PTE Reserved for SW
bits 60:59) extension which was ratified recently in
riscv-non-isa/riscv-iommu.

Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
---
 Documentation/devicetree/bindings/riscv/extensions.yaml | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
index ede6a58ccf53..7e1a59c7d911 100644
--- a/Documentation/devicetree/bindings/riscv/extensions.yaml
+++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
@@ -217,6 +217,12 @@ properties:
             memory types as ratified in the 20191213 version of the privileged
             ISA specification.
 
+        - const: svrsw60t59b
+          description:
+            The svrsw60t59b for providing two more bits[60:59] to PTE/PMD entry
+            as ratified at commit 28bde925e7a7 ("PTE Reserved for SW bits 60:59")
+            of riscv-non-isa/riscv-iommu.
+
         - const: svvptc
           description:
             The standard Svvptc supervisor-level extension for
-- 
2.34.1


