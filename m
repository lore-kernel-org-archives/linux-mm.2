Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D99B606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 09:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=2BRs8kNn;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=orqM62jb
Received: by kanga.kvack.org (Postfix)
	id 66F856B05C0; Mon, 23 Nov 2026 04:37:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F8EB6B05C3; Mon, 23 Nov 2026 04:37:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AF106B05C0; Mon, 23 Nov 2026 04:37:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0D5EC6B05C1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:37:33 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A08471607AD
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:37:32 +0000 (UTC)
X-FDA: 85465881144.19.C0F258B
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf28.hostedemail.com (Postfix) with ESMTP id EE4D0C0009
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:37:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=2BRs8kNn;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=orqM62jb;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf28.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795426651;
	b=vtsX+pZ54CCq8MNb1M33hqMGiTUw0qMdLtqki4FXQ+cjohQmsdNQyNDJvlyYkEV2Um/pGu
	ThNwRupkdpyqvbqDMY79oxVVDhdX4LPfgIQm9DI5ptIyNA6Z/couj2UC9rCCtoSvE56lXk
	vVCRTIPDb6PjJC7y32lgsB5S25NYgEc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795426651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dQUU5u79vuDftzZPq41mVfEGZTZsxAT4nxqA9JHwFwM=;
	b=arRNb+913zjDxUf8N1as7rwan11qau7AbiHfrQxW0C9hesVxliJchRpO/Ok6CAL/Kx5ig0
	gaLeJGdnwEX5axrDzB1RwuEIhfVQBclcf3MFgYWds5yWN+Q0bdTapNhF7l3Q3onz4hNq9Y
	t+eBt3l3RIK4H7wn7hF+TUiaJpra83o=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=2BRs8kNn;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=orqM62jb;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf28.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795426649;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dQUU5u79vuDftzZPq41mVfEGZTZsxAT4nxqA9JHwFwM=;
	b=2BRs8kNnJh8jUvFne0pup0kjd56RKwfZQoVTswB8jaQkT/1+UC3J0057egOH4HK7xFJAqA
	HqCywtOh7slUrHcQGQvefA6eL7zyv5hsSA1zxFFvN/6ge8RI/bO/4bG9ak1pAwLXjgZqj6
	iGcErJRTwGr5nVvFFDPmW/Nm8laVaZu6XMnvCEkeIwUojmTfuvrSIQyqYv8EdmwCWWVV1W
	ki1aQCBFjitTjq+qvrPiLfH9aOLweh50rgCPL57R9s9qzuuIqDA61unszxi5VtgurELgBe
	RanufkaLmGxg3YO/o8/JlKLnrf6Pe3A3XF6OnxlZIDqBXd9EKN0qE98NapY4hQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795426649;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dQUU5u79vuDftzZPq41mVfEGZTZsxAT4nxqA9JHwFwM=;
	b=orqM62jbjJv4cXHhrjV4L7jD4t6CApiSqCiCMjGa0zhR8JXKvf+tjoeh2jm1k5ccyk1y6u
	4vDc7mLpel0lpJCg==
Date: Mon, 23 Nov 2026 10:37:11 +0100
Subject: [PATCH v3 06/15] arm64: Remove AT_VECTOR_SIZE_ARCH from UAPI
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261123-at-vector-size-arch-v3-6-d342dae9e843@linutronix.de>
References: <20261123-at-vector-size-arch-v3-0-d342dae9e843@linutronix.de>
In-Reply-To: <20261123-at-vector-size-arch-v3-0-d342dae9e843@linutronix.de>
To: Kees Cook <kees@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-riscv@lists.infradead.org, loongarch@lists.linux.dev, 
 linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 linux-mips@vger.kernel.org, sparclinux@vger.kernel.org, 
 linux-sh@vger.kernel.org, linux-alpha@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795426640; l=1590;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=y+NTI479tyoHV6O0h6k1NetFm2TSA10tCjlo/HGZYvg=;
 b=R4duhjDRQUXysUPjCyGoikenj+2lzks0w9tUzNKNfbwsEci78RXNuIVq9fOyG8pXBz36DsOCf
 bTSsZCwaQ+5AeQSIEa48ysbBSHeolzWma3r0l38rQVQGcphJQ8frdez
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EE4D0C0009
X-Stat-Signature: 9bq73qt4tohzgp9n7dw38i1sozcrjonn
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795426650-793128
X-HE-Meta: U2FsdGVkX19dEOLEtdhnRl8oSHocVS03PZ56dmivvxHW1Bwryjxb1h5SdrCT8GN6OUFQrk99h0Z6n0CbmGQPhN+YkyqiArUjPZ2qInNTiofYQSPL0yMvscUhPkNG216NaPfwiA4D3Lnkv/vyPfgEjovknAjK8zjng1+uPUInihE7zyx2RK/dMkfU3I9/kBOQQ9g3B+7WJeB8ymP9FX6YAKqrWsJ8Zo5J5VATB4BzelKermF3Q413IZM0JDTWMWaEsI3lS9nZ6DcYjAI/Z41pIb7eQ3MW8woVau2Q/T443XtEPK2M6wVIRMmVuExYxFhH0y5SAtkRp2vamMMlmps25AOlEzNrk2uPDMQY76fmbT2TWSqJhWHRI12t6A015MY5Kxd18urMr+vtfqa4f5yLHND61VLb/+aEoHvnGsWkqhdNNS7lPTIh0oWDac4M7/VuwGABeHDeQD1lgAZA09NeaQ4pjrr2PxBVQ0uLim1Vn0D1to/7ARx8bNugOB5oDfF5QmZHGVKp+kUah5TbR8qXOHO2EKLDzh6oVfNIM+2xxNroaYMGJcJtRtAUnyiDbwvv+rDWKW7FEpi36c0RtC0rHnxgB5n84ELuunj6CXkY5P+T2H02LcwfopdupCB/DN5tnOVigfJwV79p6I1caejmztN34BNgy/2Z0ZXequ5SPcKx1n5wqLtYQM/IUt7fjeUBgfgDq24Qn9lQ+by6EJEHkeqzdMxdj7CknbJRaGPQNcrbR36a2jvHB9+iv4F2GdjjQukbxRI0yeK6p5+BjlTHKXD/mqOeRnen809H1/as2k0NbVaN40ei5wbRvOcvPVxZpRJnAx0sxvBm4qSQMIy9pldj5RMdndwCKfCNFfzx6LHTge+whI379+4iaNNA0XIb2POP7z82X2lJwFH46VuiLDKRyZbCKmYK/MaXWuFZMqumxn3fuy2QufltM5V+n148Nw/1uZMahYUJD8m2S8S
 ufRlPSvh
 nRAfHqK0fNvxW7OLZS3g/A9TngjhXbkzGp5fu1SY6TtUxQJHMpXvrChDtCMR/Sc+2DzkHQf/ZlviDyMRBqsoB+Ja7EhQfKaUKIztiHKijiFTQHZAL5NwWQO8hh9ShqouupOHN+82vJ5atoTIPmF75EueDzKoUr+oqih0E54BcE1/ZVZoKCYsOQ7D+v8P8ho/OWItvIb07ko+QE/NSQec5i8K4b5Z8/qt0E4HPNsiUrIsn6zq7W9WeSDmlI19AoPDvE5V8iElj5kfFmhMA8a3i9vIOv6XGvxPcoXix55JDRhZXbPTdlG0G6ytxSeA8Gu3EQfASw+rZWnQRBbr5yzhhes1+XO11gRyYt0fTTgXYKsdkDOekoYET4kywwVhbNE2CiU1RbtPbLGQuPsfc13eZNn8bHm96whhUh2gbEo2hC+gmaA4lh86CJ7D6Uq+q3ZFm/LtKfs9Eq4vf9HyANwUUnRMrgLZId2ESy8w92mYtOjTikH52g8feeYD+oEM8gu+wtlS4JcRXCxdXL/ZRDw5rODeRjmhkFFZ2tO5hKDE1i9oZPKVVAt9RNyeTQ7rfclV4yA/gy6d8enT7lqXuxqQ0Kb7jqua5isSHo/1FQFeMhsDnHIFfTXxid0Ux6zbzBjUGA1brpjggxaIlugkRXtT8owUqcBnfKUehXPdnGCx7BEHIrzte3lfBRwVRS/+28PFwajyEIcgApa+1k0Ljg4x02vOQgxKOKg5AZmOL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

There is nothing userspace can do with this value. In the kernel is
always combined with AT_VECTOR_SIZE_BASE, which is not exposed to
userspace and also changes from time to time.

Move the symbol to a kernel-internal header.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Kees Cook <kees@kernel.org>
---
 arch/arm64/include/asm/auxvec.h      | 7 +++++++
 arch/arm64/include/uapi/asm/auxvec.h | 6 ++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/auxvec.h b/arch/arm64/include/asm/auxvec.h
new file mode 100644
index 000000000000..de24eaaa06e2
--- /dev/null
+++ b/arch/arm64/include/asm/auxvec.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_AUXVEC_H
+#define __ASM_AUXVEC_H
+
+#define AT_VECTOR_SIZE_ARCH 2 /* entries in ARCH_DLINFO */
+
+#endif
diff --git a/arch/arm64/include/uapi/asm/auxvec.h b/arch/arm64/include/uapi/asm/auxvec.h
index 743c0b84fd30..fb51e906813a 100644
--- a/arch/arm64/include/uapi/asm/auxvec.h
+++ b/arch/arm64/include/uapi/asm/auxvec.h
@@ -14,13 +14,11 @@
  * You should have received a copy of the GNU General Public License
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
-#ifndef __ASM_AUXVEC_H
-#define __ASM_AUXVEC_H
+#ifndef __UAPI_ASM_AUXVEC_H
+#define __UAPI_ASM_AUXVEC_H
 
 /* vDSO location */
 #define AT_SYSINFO_EHDR	33
 #define AT_MINSIGSTKSZ	51	/* stack needed for signal delivery */
 
-#define AT_VECTOR_SIZE_ARCH 2 /* entries in ARCH_DLINFO */
-
 #endif

-- 
2.56.1


