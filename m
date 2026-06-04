Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51EECCD6E57
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 11:12:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 828B56B0088; Thu,  4 Jun 2026 07:12:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A9DB6B008A; Thu,  4 Jun 2026 07:12:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B89A6B008A; Thu,  4 Jun 2026 07:12:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 505EC6B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 07:12:56 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 003B7A070C
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 11:12:55 +0000 (UTC)
X-FDA: 84841967910.28.D584B14
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6B1EB18000C
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 11:12:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	spf=pass (imf24.hostedemail.com: domain of wangruikang@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=wangruikang@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780571574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=nHE4o849Fc6oTYaJ/FhiZHKK+oSUT5fL9L1iYwKuTVw=;
	b=lvO/MUaPml+LPG4jDM+58BcgWe/HdclSQGd8XxcowSTwofyfIfYL1jojffGFZ1G5XkeSk/
	RHamN52fqbz278TvvKc5c8SqWFbB0pzaI4tJ0Tuz9+/+wJOoOS/vpU59xirbm43goGotBc
	094emyLwm9xZm5jWgvMTZDsbVAbAvuo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of wangruikang@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=wangruikang@iscas.ac.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780571574;
	b=5rZ+AvziWfug7DxKnlG0NF37FXmdLqLYUlt3SMnUG1uU9uPY+Xn4nSYYrSE/b9NvdvSFEU
	guxMNZd2/qajwcnzl4flWjUvk0ruWBcAu62A8y3lN1a57cEWPlqiX8OatzRMwsRDFFBgcz
	HLwtOXVTS25yu5PYdACX0gRmhb2T0mw=
Received: from [127.0.0.2] (unknown [123.118.218.239])
	by APP-01 (Coremail) with SMTP id qwCowABX+tKpXSFqnS2YAA--.469S2;
	Thu, 04 Jun 2026 19:12:43 +0800 (CST)
From: Vivian Wang <wangruikang@iscas.ac.cn>
Subject: [PATCH v2 0/2] riscv: mm: Avoid spurious fault after hotplugging
 vmemmap
Date: Thu, 04 Jun 2026 19:11:53 +0800
Message-Id: <20260604-mark-after-vmemmap-populate-v2-0-ab6a7d03b434@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAH1dIWoC/42Q3U6EMBCFX4X02iEtCFuIMb6HWZPSDm5dSmv/o
 iG8u13WCy+9PMnJd76ZjQT0GgMZq414zDpou5bQPFREXsT6jqBVyaShTU+7pgMj/BXEHNFDNmi
 McOCsS4uICD2f1GmgvB3kQArBeZz110F/Pd9zSNMHynhD/jY8fqYyG+81MomAIK0xOo5VPtUMv
 GRv235rGwxBHEpj9XQYtbSFoqkWhOuMq0Rw3sYyAMElr20KMIu0RMgNUJg5VbztHouketFBilA
 LWcv1mdzsLjpE67+PV2R2yPzr6syAAfYDV7wbJsH6v2hy3vf9BzfYnjxmAQAA
X-Change-ID: 20260525-mark-after-vmemmap-populate-68bd790839c9
To: Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Alexandre Ghiti <alex@ghiti.fr>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, Vivian Wang <wangruikang@iscas.ac.cn>
X-Mailer: b4 0.15.2
X-CM-TRANSID:qwCowABX+tKpXSFqnS2YAA--.469S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Zw4DGr4fCr18GFy8Kr1fXrb_yoW8Crykpr
	W7Kr43WrWrJw4Igan7uw4aqFW7G3ZYkrWFgr1jk3yrZrWjqF4UZan3Kw40vrW3Xr15Ga4v
	qrs8AayrCryDAa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9j14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxa
	n2IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4
	AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
	17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMI
	IF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4l
	IxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvf
	C2KfnxnUUI43ZEXa7VUbGQ6JUUUUU==
X-Originating-IP: [123.118.218.239]
X-CM-SenderInfo: pzdqw2pxlnt03j6l2u1dvotugofq/
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: xuwd69tyuyy9ab15s7ngzut5isf73xfc
X-Rspamd-Queue-Id: 6B1EB18000C
X-HE-Tag: 1780571571-12882
X-HE-Meta: U2FsdGVkX1+fVqx5yvJ280P03LPPrlmWadbtjgLHSsCxiddGw+7ytRsoC9Dnmw3AKhNaZJmusUWBaejZA0k3e2LXzd9cZtVZ2dtazqPk7A9buOLAK8qtx8MspNG38luJkvXv/L0TWs3XpHdys4Qwlx9U2T6AyREYuX0XM36iHYlhALWJZGT+2kVwlpZ7NyxMdrEKBMncPFHi45rBwBFEZe245jC8RDwPNwSwIl0zXS1ONRISaw3PEmN8rQ+nMwsn4d2xnm3XS6F6Ts9Ab1yqexNO1UXs0x8GoAplz++zNT8s+6VjNS1WBMrvK43vtCjfuawJA8mIDBdwU3inPZuYkn1tDNBtkrGkktKw3HMLssnui33sJPzJkvILkGwV3hgUrOtaF2b+j3Yejnyml1I7o8MkKM85aTim0Jw1qp76nroZg9J1Tqw5jxybgDxz0xgoI+LuObhm2Jz+wNzL29lRf+JE6ENi4r4SR/o2f3FQYqaB/sNkhAaySaZGY0xzyCMyczfEpqp0scnCP4gaoiBguGXZDufxKQI7vtJsiAHzRlX8jt03rRloOFA1roQbxI4Omtj5UqTt79/pwP+Mqe6KcwCBeKjzFD7/2Ca/yDE+TIhybtJHEhWliSbmNaKJ/xO3yizhIdMfCEbxzT6ri0V/jC6aEppp8U3SPlznUwyVgbz8M/d5+lJ6qO4VRfwWgYsSrEpVXaEWX/y0b5dE0FUTupfFLz5KqWtfHEl/3OmtYLNAd/6P6K2bC7iFsoh+uDeC03ZvINbMLp2qKBP7eTwzzMMBaLAAuGGRpgKLbdAhWdh/xL8kB/AjZMPxNroauxVotL8B9Io45tHS9yXIFaF8igSAPEJuiRQm7FbL5xWf/pLEYrn+rLvw1ZNlwfp9INN1fqXYeuSPzcfH5xDiw9EnhPiyfxMFbY8QQAN49BZ9CXzpiiKK7zoZcTKtFHT2iE3gpX9AdE8zhWYiGPnoIpM
 5fnUazCe
 vK5vNPBeyXSaejj23NgfpMBsYMAahBjNb0VvXvQCpnX1V2Uy9FWMvap/Ltb5nDbdsU78F3LQs1EiZi3i6nbtO7mT8wJG4f0ZAR7/+a5zD0Sqjupkonosoi7jt66AesvG3E0af+1Cd90nw9YAq8gY7WVUuTQpiERrpYsmV/jiGT0wGo4iio5J/Co1E46V4cZSsvliCriAd+q21GPc7KWlqucm6E6GX8TXqmliOI5VMjwOcuEMPxO654IHBsGPkM4vTHndyRzW1eV+/UODHDX351rJ4EA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Patch 1 adds a hook and should be no functional change on its own,
whereas patch 2 is the actual fix, which depends on my earlier kfence
fixes for mark_new_valid_map() [1].

Found while testing AMD_HSA/ZONE_DEVICE on SpacemiT K3. Using
ZONE_DEVICE requires another fix [2].

[1]: https://lore.kernel.org/linux-riscv/20260303-handle-kfence-protect-spurious-fault-v2-0-f80d8354d79d@iscas.ac.cn
[2]: https://lore.kernel.org/linux-riscv/20260309-riscv-sparsemem-vmemmap-limits-v1-2-f40efe18e3cd@iscas.ac.cn

---
Changes in v2:
- Split patch in two, hook point and riscv hook 
- Explain hook necessity in patch 1 message (Mike)
- Make hook #define based (Mike)
- Call finalize hook only on populate success
- Link to v1: https://patch.msgid.link/20260525-mark-after-vmemmap-populate-v1-1-e698d859ba16@iscas.ac.cn

---
Vivian Wang (2):
      mm/vmemmap: Add a post-population hook for architectures
      riscv: mm: Avoid spurious fault after hotplugging vmemmap

 arch/riscv/include/asm/pgtable.h | 4 ++++
 arch/riscv/mm/init.c             | 6 ++++++
 mm/sparse-vmemmap.c              | 8 ++++++++
 3 files changed, 18 insertions(+)
---
base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
change-id: 20260525-mark-after-vmemmap-populate-68bd790839c9
prerequisite-message-id: <20260303-handle-kfence-protect-spurious-fault-v2-0-f80d8354d79d@iscas.ac.cn>
prerequisite-patch-id: fdc42f2647e21d111f44a6532887a6705cd470a9
prerequisite-patch-id: 096fa339c84c36643ae4311fd8362dc63e23d950
prerequisite-patch-id: 305c876a5f4a23a840a8142aea79b796ed297545
prerequisite-patch-id: d78cb55d6a616b1170f06a401c8fd44acd11e5d5
prerequisite-patch-id: b02b4a76e94f3e2821291d4c23b46f6e5ecf5203

Best regards,
--  
Vivian Wang <wangruikang@iscas.ac.cn>


