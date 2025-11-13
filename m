Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FE2BCCFA18
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 07:28:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A668F8E0008; Thu, 13 Nov 2025 02:28:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A0408E0013; Thu, 13 Nov 2025 02:28:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CCC18E0015; Thu, 13 Nov 2025 02:28:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5AF208E0008
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 02:28:41 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2B3FA12E25E
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 07:28:41 +0000 (UTC)
X-FDA: 84104756442.04.D7EECFB
Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	by imf10.hostedemail.com (Postfix) with ESMTP id B0CA0C0005
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 07:28:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.84 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763018919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5k4U/oL50YzY9Z5cG6VeDMw29DjkOHCj2p8aQcjSwcg=;
	b=hLoSM1AdNWK7PGLQJDocVM5/xN+Y242J23VqaIaWOSpzR9TDKA5fwvZI3a14u0H+SaWD7y
	fN5/nWNtzQZ7Cx5aUZm5pnG3BB3R+9BPIOv9IFEoAPy8Rb03fXuVID8zSKYwjPSUxhuPPS
	i6MmPEZXO6IF20zWp6o7MKSpTdbUZc4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763018919; a=rsa-sha256;
	cv=none;
	b=70DnVKPvcKM1KU3NhZT/d3m4D0zp5Jk2Y8noKaHHJguEDChQ1X/GYMYxzg672Y1oC8WVih
	J/zxhuYTf1hBhD+IG/TNn7dv7FZN41ATkEwj6xsUHWAI7pNGKxu3T1LpH1TA1lPfqheYbJ
	ozBgGnSPvTPrGedjRDG/s0tHALHRbZA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of zhangchunyan@iscas.ac.cn designates 159.226.251.84 as permitted sender) smtp.mailfrom=zhangchunyan@iscas.ac.cn;
	dmarc=none
Received: from ubt.. (unknown [210.73.43.101])
	by APP-05 (Coremail) with SMTP id zQCowABnbG2RiBVpVTOWAA--.33691S8;
	Thu, 13 Nov 2025 15:28:29 +0800 (CST)
From: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
To: Andrew Morton <akpm@linux-foundation.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-mm@kvack.org,
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
	linux-riscv@lists.infradead.org,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	devicetree@vger.kernel.org,
	Conor Dooley <conor@kernel.org>,
	Deepak Gupta <debug@rivosinc.com>,
	Ved Shanbhogue <ved@rivosinc.com>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	linux-kernel@vger.kernel.org,
	Chunyan Zhang <zhang.lyra@gmail.com>
Subject: [PATCH V15 6/6] dt-bindings: riscv: Add Svrsw60t59b extension description
Date: Thu, 13 Nov 2025 15:28:06 +0800
Message-Id: <20251113072806.795029-7-zhangchunyan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251113072806.795029-1-zhangchunyan@iscas.ac.cn>
References: <20251113072806.795029-1-zhangchunyan@iscas.ac.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowABnbG2RiBVpVTOWAA--.33691S8
X-Coremail-Antispam: 1UD129KBjvdXoWrZr1xtry3AFykZFyktFy7KFg_yoWkurb_Ja
	1kZa1kZ3yUtFnYvF4qvr48GryfZFsakrWku3Zxtr4vkFyUWFZ8Gas7t345Ar17ur4fu3Za
	kFn7XrWSgrnFgjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbP8YjsxI4VWxJwAYFVCjjxCrM7AC8VAFwI0_Wr0E3s1l1xkIjI8I
	6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7
	IE14v26r126s0DM28IrcIa0xkI8VCY1x0267AKxVW5JVCq3wA2ocxC64kIII0Yj41l84x0
	c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2
	IY6xkF7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E
	87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64
	kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVW8JVWxJwAm
	72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI
	1lc7CjxVAaw2AFwI0_GFv_Wrylc2xSY4AK67AK6r4xMxAIw28IcxkI7VAKI48JMxC20s02
	6xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_Jr
	I_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v2
	6r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcI
	k0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4U
	JVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7IUnTxRDUUUUU==
X-Originating-IP: [210.73.43.101]
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiDAcFB2kVaThz7gABs4
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: B0CA0C0005
X-Stat-Signature: 4jcoin5rtqopcithehteasro1bytn1c3
X-HE-Tag: 1763018918-417219
X-HE-Meta: U2FsdGVkX18tqs8o2CbcZRd5Svtn4a3SYc2svUlG0JLcRWL4YVf5P4IE/nvtBatMPN9uTbLMf8DW6PSUspK89SyvpIBSVCnOYkGfvuE/Ruff2QhFx+X0gfL90EtMVAB2a65hNQeemGuCrRnI5RWlOZyRWVMjW13Rf0GLJ27ARcs9dywfpGQsThUwBpSW0rOxIFv835x4Sxuiw8VtA4baEijEZ0MgXXRHvpuxBq74nbPZUTk6t2p9IEwGdKCNWP5T3SWAXv7kSYRRZmS+0npCu/vJYob9hMPwoEp6sRglIPniS1A83K462oOK6+me3GlEmdTXbEdz7IbjgHx350RA5xz2H2WxKAN4gJD2aXFfd6gjveDkFv/BQPcTNioWBRXxE+IaVqIUeIFZCTxf/jUOXea3DHndDaze8H3bw0GnhYp92rF6YaoVJUMkK7KuNjzoJp6hMMyuBSTFJRiBX7IxiIb06uMp6cuRjxGdm1tUQD+t/iuRW44V63cjGk7DKaP4BLan0CUGq2QW+N8hZO8a7PnpXftoCGyoHYJMVd81H+yhVnAPD3VaK4U4pbrW1AUR8rAy2dL1A4qOenOQWAdyktRHz7XI/eFhtnj14fYVz7wDxFjh1zFdysimo81BEOErP9p7h9EdoE3IH2bFaKVA94h8w0DWeuuKeY8acIML+f2FTlru+DNTUXV/dpnEHg6hyUE9Fe40m+SCyM4TlZ3GEeDEgXyXC+kbMsN6gtxfh0sMQ00QGF/tov+RH3/RJCP6LarY/LhgV8OqkXk7XICh7I2I5jj1VNdKrZh3fFNcxw7M3v8B3kfgojz63THfgnwnbDO9ocoqkOfxQVpZkGsD97jV1a5gKEeg9dAfitn4fXAHoVr36uHQeeXP2kh1MqFM5x3ht2JqPlClcFJLEb3j+v6lmnQqTsHmwXiFQfS7rgIdQ63tnA8npGsmN8Cs+Evydtnr30hTwkYDEJDSbVJ
 YwvKecOH
 sg9jlPPGGszqMQ0SoPaoQWHJaHkPCgD3QhVP/8/+a9APOSNtMSz3O8P/J2fYZt0soF0Qz8yQk1Z2bi8h2E21ZchqUZQIk3e53ct+7IaYTrnFYAP8Ss/m2Q06igG1ec7bsbvjU0u8m9jfxjfA93sl1ar7Xe7heF66TaF+Ij4BkWNpm/XhJPHz/pSqqcbFSG3vfbKrmXy1Pa5Z46mUuY9C2J0+8a8wqkS36TZBZhsJl2mEDan1DRTtM1+zxk9i3lWvrgut+D3GVBmfaOrqBk2mf3rx/XZo8fB5pkICzy2igBIE5p/4=
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

Acked-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
---
 Documentation/devicetree/bindings/riscv/extensions.yaml | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
index 543ac94718e8..194ef4754452 100644
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


