Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 618B9606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 19:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=h72fjJkI
Received: by kanga.kvack.org (Postfix)
	id 47D496B05D8; Thu, 12 Nov 2026 14:32:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42E3F6B05D9; Thu, 12 Nov 2026 14:32:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 344866B05DA; Thu, 12 Nov 2026 14:32:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 144756B05D8
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:32:37 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 21E17A8B9A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:32:35 +0000 (UTC)
X-FDA: 85427463870.28.766492F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 595EAC000E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:32:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=h72fjJkI;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794511953;
	b=Nh9lnuM4sktbkPYDhos1y4LJvE/n2xO5V/MEr7zNJydeTY94rPNcQP2uzIIwmTGPjEhP1S
	IALTFir76H6owbpHBAsJ5peVgc94htUgNJbrHjaqBvVO0FSce3xy0WkoGpvsfS5/hau/HE
	Fsfma58LmTRfhzbRax35AIO1BHJ50Js=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=h72fjJkI;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794511953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PY286/snnbEF5QyixUAEHWZvLTqyb1OkbulZ3V9rDhA=;
	b=ag5gdnIev/5t0ug8XeFhl7dxhj9Jp/e9QaP6kfpOYxfUSPrvC6g4wvYpv0oBCaUZzn6kFZ
	2NV5+oZS29P57RO9gb09MOojlfiOUJy0npYSSMuR28kVt9QJNhGyWTGfzH21aFX1AFaNaP
	6MeCpu91pG7t9IrEX3ygGCgL28g6pWs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6AD1362433;
	Thu, 12 Nov 2026 19:32:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4F421F000C4;
	Thu, 12 Nov 2026 19:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794511952;
	bh=PY286/snnbEF5QyixUAEHWZvLTqyb1OkbulZ3V9rDhA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=h72fjJkIt+Va71O69daZ2arnUrd8jTdiBVApIAer0TGjgBuC0c3GWO2JIn7yxg1E/
	 soIzM0uy+i9p10EcjDxQk0LUSWGF+I6AmwdRErIL/d631Pe3mbD39m2difcanToBX3
	 d7apj2AGagrXKdki612FGoiOc60Vs8V3QXoY9gAM=
Date: Thu, 12 Nov 2026 11:32:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Xionggui Chen <evers_chen@163.com>
Cc: David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 chenxionggui@lanxincomputing.com
Subject: Re: [PATCH] selftests/mm: Handle implicit read permissions in
 madv_populate
Message-Id: <20261112113231.ce39807d300f102e6763a87b@linux-foundation.org>
In-Reply-To: <20261112031811.56500-1-evers_chen@163.com>
References: <20261112031811.56500-1-evers_chen@163.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6wup114jn7me7uigtey9ge1ws1brrc7e
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 595EAC000E
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794511953-715183
X-HE-Meta: U2FsdGVkX1+QWcfVUhaDXs2GZbJWZA7+W6G/ORWAOTHP6E5tUgnOXZ+eF6V52oD586QmqNjU1t69BP64hueeHNHWlgRmGBe1QCD/Htmp6weeViiL+qZLeCAMw0/UnQekdnQYr1EEqTFeLYzPCP8HkCNfl2VO8EK8pkmjmBBIf9Fi/1ly3VwqSbX+rmxcZWtpqUkaO1+Go5fIYdLXrWRqe7TVb2oG+xOEqStZDymdTws588nWNzh7WZQ2mC3k1apE8JrsAv3CydrCbvsl9q7emKjLXkb5p8c3GPcwzxVKKGMyofp1mE2BONPooiMk6usO97w4gZkNuho/oqKaPQeox2K2hj69HzECRQuNZ0wH6U+wSm0EgLEXqxvkVsXCm9W0XYQM0icQ3r8xJPcVatKzmByK0XwtLd5pA0JdhY5+X+gdIazlEpcat03R6foEwz1B7uroF4bNvp8hp3Zqtm46myu+0aviNZstCqPyUaHhRFth0m8C9HHPiIu3qGsLj8Wsegfb9C24y/82UFXEiV6WiMGUX6NrDuPuw4XojNBhRTa+ClBCY4njkT6XKCL8BQa50lr1b/MaGSF6To0hQkzlqChY2fbQ7NGnBHvVYhx6pIuwk1rGssdbNxkysS/tXsDaYhzi02VsxiyoTiBwbDV3vOI9gec6SSW0tpCx1hO+nAOdWyE/KZPuCH/GJ5xwlRvcKsCGvq6+L7yHv1avtGbtrEE4pOZM/K5N47Z+BaBai/ehpAsSqY/4M7TcC2U399aOlD2ZXIJWYNVq7LLheekBRGjfh/wDkBSFX18yJjUEeLAHOYpKQUzsG+pLGzkHiZpFBlq882IEQ0PKfTrlIp3CVFl4Fzp36zCGo1IZgD03Pm+qVWjcAetlk9G51RL/ogTBFkx3NPt1Ag36yBJqYPtAJruYkZPQzAebhJqwA+HqA6LlI4oezvcySkUNLlNQFsZrUjahkYyVFo6UR5je80L
 XGm1GUNM
 LH2FvvXFk4VdKrFnX0MxDQuRcoZ8VtIJcxDzbbYrfNn74CDW/EhUon2/RRv8eYe6h6mMvOg4wRQsF/+7syQqycBq4iojw62BjvIQ4fAo5DWrPXxPjAYuNFPyntMM1VL9+ZTFg2VVNjscEPn2nlX/fQm2tcHk7WJ4K9V3+P39euhijQoZxCzaRAhi/djSCGgU/nu2eRgBHiG6L0Jo0FriyJGKluxXmDzgNt9iGa7Lkhs1wyQBlNPFF69brsQV87ffkxS9Vyw3SRU8VG9OqEjHRZNFDAqXQTfn2ecXW6MmCpp4lVhuLtwAnC21tkyQ/mel1Z9BHgpLxZR5J3byC4bhVdlhIvSxFGvLIsioiK1YBALD4R5yhKFkeq6E4i0uDRtXY0cdKEPHKWRB9VOU6Yy4GeUuGV0mywL6fCOaO7Tr8tgujUPZbgH7DxFEF4WhF0V1xDQ9mUdVFFP5N5vY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 12 Nov 2026 03:18:11 +0000 Xionggui Chen <evers_chen@163.com> wrote:

> The madv_populate selftest assumes that a mapping created with
> PROT_WRITE cannot be read, and expects MADV_POPULATE_READ to fail
> with EINVAL.
> 
> However, some architectures, including RISC-V, may implicitly grant
> read permission to PROT_WRITE mappings. On such architectures,
> MADV_POPULATE_READ succeeds, causing the test to fail incorrectly.
> 
> Check the actual VMA permissions through /proc/self/maps and adjust
> the expected result accordingly.
> 
> Add a PROT_NONE test to verify that MADV_POPULATE_READ still fails
> with EINVAL for mappings without read permission.
> 
> On RISC-V with Linux 7.2.0, the original test fails 1 out of 16
> tests, while the updated test passes all 17 tests.

Code looks good, thanks.

The changelog is a little imprecise.  

"some architectures" is too broad - this is purely riscv.

The wording suggests that a readable hardware PTE alone determines the
result.  riscv can have readable writable PTEs without setting VM_READ,
and this test still expects EINVAL on those systems.  


I altered the second paragraph, please review.


From: Xionggui Chen <chenxionggui@lanxincomputing.com>
Subject: selftests/mm: handle implicit read permissions in madv_populate
Date: Thu, 12 Nov 2026 03:18:11 +0000

The madv_populate selftest assumes that mmap(PROT_WRITE) creates a VMA
without VM_READ and expects MADV_POPULATE_READ to fail with EINVAL.

On RISC-V, commit 6c7559f22b6f ("riscv/mm: ensure PROT_WRITE leads to
VM_READ | VM_WRITE") makes the kernel set VM_READ for mappings requested
with PROT_WRITE.  MADV_POPULATE_READ checks this VMA permission, so it
succeeds and the test fails incorrectly.  Whether the hardware can read a
writable PTE does not, by itself, determine the madvise() result.

Check the VMA permissions through /proc/self/maps and adjust the expected
result accordingly.

Add a PROT_NONE test to verify that MADV_POPULATE_READ still fails with
EINVAL for mappings without read permission.

On RISC-V with Linux 7.2.0, the original test fails 1 out of 16 tests,
while the updated test passes all 17 tests.

Link: https://lore.kernel.org/20261112031811.56500-1-evers_chen@163.com
Signed-off-by: Xionggui Chen <chenxionggui@lanxincomputing.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
---

 tools/testing/selftests/mm/madv_populate.c |   67 +++++++++++++++++--
 1 file changed, 63 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/madv_populate.c~selftests-mm-handle-implicit-read-permissions-in-madv_populate
+++ a/tools/testing/selftests/mm/madv_populate.c
@@ -69,10 +69,38 @@ static void test_prot_read(void)
 	munmap(addr, SIZE);
 }
 
+static int mapping_is_readable(void *addr)
+{
+	FILE *maps;
+	char line[256];
+	unsigned long start, end;
+	char perms[5];
+	int readable = -1;
+
+	maps = fopen("/proc/self/maps", "r");
+	if (!maps)
+		return -1;
+
+	while (fgets(line, sizeof(line), maps)) {
+		if (sscanf(line, "%lx-%lx %4s",
+			   &start, &end, perms) != 3)
+			continue;
+
+		if (start <= (unsigned long)addr &&
+		    (unsigned long)addr < end) {
+			readable = perms[0] == 'r';
+			break;
+		}
+	}
+
+	fclose(maps);
+	return readable;
+}
+
 static void test_prot_write(void)
 {
 	char *addr;
-	int ret;
+	int ret, readable;
 
 	ksft_print_msg("[RUN] %s\n", __func__);
 
@@ -80,9 +108,19 @@ static void test_prot_write(void)
 	if (addr == MAP_FAILED)
 		ksft_exit_fail_msg("mmap failed\n");
 
+	readable = mapping_is_readable(addr);
+	if (readable < 0)
+		ksft_exit_fail_msg("Cannot determine VMA permissions\n");
+
+	errno = 0;
 	ret = madvise(addr, SIZE, MADV_POPULATE_READ);
-	ksft_test_result(ret == -1 && errno == EINVAL,
-			 "MADV_POPULATE_READ with PROT_WRITE\n");
+
+	if (readable)
+		ksft_test_result(ret == 0,
+				 "MADV_POPULATE_READ with readable PROT_WRITE mapping\n");
+	else
+		ksft_test_result(ret == -1 && errno == EINVAL,
+				 "MADV_POPULATE_READ with write-only mapping\n");
 
 	ret = madvise(addr, SIZE, MADV_POPULATE_WRITE);
 	ksft_test_result(!ret, "MADV_POPULATE_WRITE with PROT_WRITE\n");
@@ -90,6 +128,26 @@ static void test_prot_write(void)
 	munmap(addr, SIZE);
 }
 
+static void test_prot_none(void)
+{
+	char *addr;
+	int ret;
+
+	ksft_print_msg("[RUN] %s\n", __func__);
+
+	addr = mmap(0, SIZE, PROT_NONE,
+		    MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
+	if (addr == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed\n");
+
+	errno = 0;
+	ret = madvise(addr, SIZE, MADV_POPULATE_READ);
+	ksft_test_result(ret == -1 && errno == EINVAL,
+			 "MADV_POPULATE_READ with PROT_NONE\n");
+
+	munmap(addr, SIZE);
+}
+
 static void test_holes(void)
 {
 	char *addr;
@@ -266,7 +324,7 @@ static void test_softdirty(void)
 
 int main(int argc, char **argv)
 {
-	int nr_tests = 16;
+	int nr_tests = 17;
 	int err;
 
 	pagesize = getpagesize();
@@ -280,6 +338,7 @@ int main(int argc, char **argv)
 	sense_support();
 	test_prot_read();
 	test_prot_write();
+	test_prot_none();
 	test_holes();
 	test_populate_read();
 	test_populate_write();
_


