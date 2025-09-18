Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35651CAC59F
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 08:38:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECDD58E00D7; Thu, 18 Sep 2025 04:38:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E86BD8E0093; Thu, 18 Sep 2025 04:38:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C35BF8E00D8; Thu, 18 Sep 2025 04:38:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9BD778E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 04:38:16 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4E607BB7EB
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:38:16 +0000 (UTC)
X-FDA: 83901718992.09.81B89D3
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	by imf25.hostedemail.com (Postfix) with ESMTP id E4EB1A0008
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:38:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.81 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758184694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wZtEtRjLRYiSKzR5iF9j9PwvX3R4WACBPi6T+tmKUMI=;
	b=8YobGkN+XA4vkmOylwsnbY7yZ27amlgU1koBELR5hM6D0tlY7Rgh5d1SjV7GsHSHAAOAIf
	tGLOZyuf/VMK39gqVKvt+YNsAc58pxmYMlGZqVBVsibBRikj5+HCAdOX6vKREYf8YvKAvo
	2OSF6065TGASNjK/l/1IMSjg9IhlipU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.81 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758184694; a=rsa-sha256;
	cv=none;
	b=lk4DVi3ElCJyzeLa5eWOZ9hpU3KhOEnUHbW6OqnTHt9GLEyPljy8j+aqe1L7wlaEZd3Cr4
	sogSuda3Ck9ZNotA2+cKjPJ7SjK45m63XyvSTNl5tPyGoXEpFRgtcvXFkOMmqDKywDZfbl
	dFrwgPjyoUvRFx7XIy50mhPIg+YN6lk=
Received: from ubt.. (unknown [210.73.43.101])
	by APP-03 (Coremail) with SMTP id rQCowACnu4XjxMtolHKCAw--.43062S8;
	Thu, 18 Sep 2025 16:38:05 +0800 (CST)
From: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
To: linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
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
Subject: [PATCH V14 6/6] dt-bindings: riscv: Add Svrsw60t59b extension description
Date: Thu, 18 Sep 2025 16:37:31 +0800
Message-Id: <20250918083731.1820327-7-zhangchunyan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250918083731.1820327-1-zhangchunyan@iscas.ac.cn>
References: <20250918083731.1820327-1-zhangchunyan@iscas.ac.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowACnu4XjxMtolHKCAw--.43062S8
X-Coremail-Antispam: 1UD129KBjvdXoWrZr1xtry3AFykZFyktFy7KFg_yoWkXrg_Ja
	n7Zw1kZ3yUtFnYqF4qvrW8Gry3ZanakrWDC3ZxtF4vka47WFZ8KF9rt345Ar47ur4fu3Za
	kFn7XrWagrnFgjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbkAYjsxI4VWxJwAYFVCjjxCrM7AC8VAFwI0_Wr0E3s1l1xkIjI8I
	6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7
	IE14v26r126s0DM28IrcIa0xkI8VCY1x0267AKxVW5JVCq3wA2ocxC64kIII0Yj41l84x0
	c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2
	IY6xkF7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E
	87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64
	kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVW8JVWxJwAm
	72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI
	1lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_
	Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17
	CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0
	I7IYx2IY6xkF7I0E14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0x
	vEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIev
	Ja73UjIFyTuYvjxUa0tCDUUUU
X-Originating-IP: [210.73.43.101]
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiBgsJB2jLv7wXwAAAs0
X-Rspamd-Queue-Id: E4EB1A0008
X-Stat-Signature: fotphcoth8f8q4akqw38ift6rhnag6je
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758184693-442663
X-HE-Meta: U2FsdGVkX1+eAKTcyZn8TnZq8QkC1VQ6n2/Rd1KE9QHYomDRr9R5S+9+kvU097ucdQqI+uNlKM1Kpw9eepyn06bHl2WnsiCpXRno4lgsUsVb0HPDqp5InlZi/St4G74PoEqcZVmgWvcwCbovW96EWZ7/TVmZ5gqA6PhBqE52Eb90I7W61zJelrdFa7YDBzArHDeQefk8AnfYoZ9eQdQ4wdraLRA1q7RGVQo5rz7JGcNwAUpHECm3mhBgW59iIHJ1rbQwW8gP+rmKQBT4Mm/y3FbaFnFALmLT2ylJYD/ggqztMzxmGArY0d3nm2QIGSZZQFruk9fjnuAFxc8W+sf+43VkAGbb6H+qFhi/rEc9J8nLxIp9uwPPmKKE0WJKHzNMN8lmcnOI1vQLkU268UhHJiOf+/zc/RmqQfF2LVFwHeS8GASfQuwCFd6K0z4fDTjdk64uSe9v14NzgWEghDD4Ot7FfhbqjGCxW8307iSteCv4p5BO+cPUcnVMpTO6jhSVeKQhyotmtdgRMFhb4BOLRiDpgxVd6yLu4vpGVl7HymBEBD1ln8fr6Z2kHOlXdRWadbXbQsiWIp7CWwPAC5y1NpP7IZtWJtb6hWcEvuqLB1CCFZCvF6C5FfNMJcHWxvVmdo1Fl5qmKnKmEqUK8NcSja6LEzJFjiwrXIWCxsVhRiWzic+85/YVHQxOE+Tu31xR5ih/bO6dATdXiyEoEki7FDnZdnTXkSPcDdbFBBrz+lICip2AZL0ruxbQZKUdiW5gAtJmrVXDFplnBYCBVQoYcwTO8NnfLE2DoxSK9DpSptRnqTVhH0bRFUn95xVyVGMkzzqR79l4eyQ5ppwne3O6yK0mr8r8CeRZUvi1skUGf64/uRH4Yt3oT5/kfVuadc4rJOEGFEVnmYji9VdvaaayJ22kja6wFBCtTbTdeu/QZtpI9agIka/N+noFv2/bTTVW6bwqiYuFDZcZsfNQktv
 MAKukd7+
 fRwIIzV1KgtlfJC4XQ6CVZDdmrF5PJzwQvSvblLneqXdJN86cP2Rt04KLa19BG9lpQdYr+n/VvcOO1kmeN9rrhfP3qrDcPrIA/MYy8uicy2rKw85++rvIFOZQLUluRj2mgZhjQXgnDjj+RzIaMWdQaFKwy2sr2qgG3Q4qCZ8KqgQ1zLZAZB1fZhD0etl/s5cFMVbpzfH4A+V2blgSX3EYkos8jgZvTdy5lERqKMul2b8sITw=
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
index ede6a58ccf53..bce4132f9c89 100644
--- a/Documentation/devicetree/bindings/riscv/extensions.yaml
+++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
@@ -217,6 +217,12 @@ properties:
             memory types as ratified in the 20191213 version of the privileged
             ISA specification.
 
+        - const: svrsw60t59b
+          description:
+            The Svrsw60t59b extension for providing two more bits[60:59] to
+            PTE/PMD entry as ratified at commit 28bde925e7a7 ("PTE Reserved
+            for SW bits 60:59") of riscv-non-isa/riscv-iommu.
+
         - const: svvptc
           description:
             The standard Svvptc supervisor-level extension for
-- 
2.34.1


