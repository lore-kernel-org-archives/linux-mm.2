Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72E09606A329
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=v4jjP53A
Received: by kanga.kvack.org (Postfix)
	id 4DF006B05B9; Wed,  4 Nov 2026 14:02:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48FB06B05BA; Wed,  4 Nov 2026 14:02:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 330A46B05BB; Wed,  4 Nov 2026 14:02:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F34E46B05B9
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:02:14 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6FE5C1207F5
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:02:14 +0000 (UTC)
X-FDA: 85398356988.23.3E916F8
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf19.hostedemail.com (Postfix) with ESMTP id 911311A000E
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:02:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=v4jjP53A;
	spf=pass (imf19.hostedemail.com: domain of 2dgodoy01227@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=2dgodoy01227@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793818932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jgTZFnwXdV4AJUne0nV03xTEkp3bQhCd9JPNdkYZauc=;
	b=8UlXRINx6OcugtSjlR1WDZ3nkYUx1uJTHVL/IrsJfwRpeEIa5JexVIOk/Cv41txzIMq+12
	uby8vvdopV7b6PzqFmbdhWOKsNzD9NFV55SnuP+DTeG5/O0iKhy5gd7Kq8bU9HdjA1t9h/
	AUWUBYCjg7vK1Jn7BMnWQiPI7EMYRR4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793818932;
	b=ob7nBj0Ubhrx6/DeZszOef0IgPfYF+XFgG9ttZT6CxlyvAsbI0EvNBpz5HQDjAmeBvuUKB
	+0Zg/X4J4QgZRn8iV4PVi6BSnbI75enG/nsBGfb1wt3dynAZFoAk48o9/5aGJIT0z5MmVe
	1LDhpGfnsRFKfDGW8ykPUSEkgKUdW7s=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=v4jjP53A;
	spf=pass (imf19.hostedemail.com: domain of 2dgodoy01227@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=2dgodoy01227@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2e987a2ba0cso6033325ad.3
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 11:02:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793818931; cv=none;
        d=google.com; s=arc-20260327;
        b=deM9o2e0QCqglc49X3qiU4rdHwbg9TRY7QM5yDSn6BH4ILRTHDEEI/eAx3u8hUSsH9
         hEbxURcvZ7k5yG9OVmCTqwBdxb7kadHJWub0gJ3idCAZyaUlHdIdDQK702FZFaGXQnbX
         iDnXypLjv6WcXBiIE3XdjARxJGpQaxyPy/11XanwSuVGaaFJNiCt4gNEvykiE1/eosdj
         abUQjPe2D+XCopFlpDTg4/kXIgj5b8apdWNl7XhNV2ne0bN8+UC2JVrHBiANnpKE0Zym
         1KSeVO/URA4/S+vduTtIUADe2NdQRNVFVRO3sSYCUQGvtqnrxSWO1ncOm+a7RrUtKsqO
         Vmpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=jgTZFnwXdV4AJUne0nV03xTEkp3bQhCd9JPNdkYZauc=;
        fh=YxaQX7GTjfBsN7A2Jl+A9yP6mmGOQanoqU6QROKhVaA=;
        b=JyjX/Ui+yisJDjXDaYdLW3ThpeHcugV8qYfy3WLodncyKeV5Nkkp2yaahIjbOpJ7PV
         tuvAso71fldP4gs+fsIVemAjJa+euD2u23T2t3ztYVYe+mJEvTo1Urh4ZIpg6LIfCfEf
         tDPI/rNUJGsZ0r0patzMF2X5P1h/oNJDPRTweOPra1IK7McrA4RWqM48+4O8wpAWIlwn
         UVpo4ES3Rzk4tu6MW4yalT5aufoyjgKQf6oQ+78ui8/ISCyEfPhS5Rk7ogoUacquCC+A
         xPkT4c+jPH6+SEKi1wOXAomYoZeH2e9tCaBDPTea7/FWzhbcxOsYOF6eKVs5U4n/5BSH
         uj1w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793818931; x=1794423731; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jgTZFnwXdV4AJUne0nV03xTEkp3bQhCd9JPNdkYZauc=;
        b=v4jjP53A06N40h9riAM8THrpsYFmAOr3gMtrJW1UI+Rv7hWYLhrGmVhSBAQVepPSwH
         2qydTJYbt/lP18gMk6Ssp8XjqIq7r9yxjqtESCErcQySyFZThDDNHKUvncxB372uiBxX
         4ab0VZ7yi9hP6ZL2znPIn6tqnW/h6EsoRcPLo/768LY7yyp8sBtgWW75VxeVKcd2kk5u
         x+mxOBb0Hgr83qY6j2qSEDIh1P9YrPhgobvl7/czZXdJGnuBEdP0mH+1FJ9Ih6dcILCG
         3twsFlojZuL/pBVxWW4H8VJXijLTfaRl6bkEps63aCMV7eTeDfTFsAHRwqaOYMiOxQO+
         Obiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793818931; x=1794423731;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=jgTZFnwXdV4AJUne0nV03xTEkp3bQhCd9JPNdkYZauc=;
        b=oHUWotXscsllNbTHW40iai/QHHI/d7CCgclI2aQuLg0+jB+RZHevM/qS6BjO+cK50y
         6Dgf1kUToRKUbpVX+gYjI8WVU9iaGJjHhXPSGqGL2JJ4+bXhQMgNmoJhpewOyjlYb5KJ
         vFs8djovfpjz/eXkxlKqYy40iOsnDWwSina0n2YiGgBrK114097uYEo4IPHqhkMQUOtO
         vi2pEcDE+QBVpVJm54kES0ZX8dDRHb6Q2jL8sl49+PrdO4XmW3ORxUEKCwX715fURus5
         6SGgm1izgvFVcCpapLfaJdNuFkjlZx4Q7JSb1mRyCJGdRHia1veTvdR7DgC7ZNWcIBDz
         jBMw==
X-Gm-Message-State: APuU4Z8R9g0hdP/Mtb9j/LivCYqu25NRUAu96YSH9FlAJ0UkMa3f8iX0
	dXoOA24gLN3gNQtUEEf46LTebXtBAnGuvHDTmy/8xFZACdhFwLd12TCPL+mkLNqEk2lMOWqUEa0
	JeyIpE9v/YI81TmVjQMXx8GlmBPitMvXK/+DL
X-Gm-Gg: AYBFou0bxjM4xTOIqExCS81UqpKHRtVvBiUuNy/AvjuejUeW3iWBb50eR7p6OYAWcbW
	N5pt4heBwA5Z03p3qvAUoceiiZ88Jiewe0sXJd2g+7WVPnIUpKe6hvTpp2QIOzkiIQ4aBzne4qZ
	DTZriuEw6MhiRd+xaP/GQl5LBQKmHrOv2L+hh+fw7N/hC6T1/XItNsXHT0PKtxpeaL/fCpG35sL
	7xna9G8GneLkyCrz9JVL2UXUW21KqnlS8hakoKAmEOzq6nwyLUMYask6uZAxDg5E+2RSajkdvUv
	MOdepKp/M5Oxpo3s9K1lXby/2fY+MIznMVrAbC2LQoAdOeT2qjzXm/NdeQysxAvWMB2Oli2F4gM
	vqXab5oSsXH1LLz524+/gAp6SVIWuMyfnf3pxg47M8MGSbC3M2X2KIkI2y4Mwoq+BZQuOB5wa6e
	8NEkJ3xiFUBhNX
X-Received: by 2002:a17:902:ec85:b0:2e8:965c:aedf with SMTP id
 d9443c01a7336-2eb364c5da0mr169489445ad.42.1793818931383; Wed, 04 Nov 2026
 11:02:11 -0800 (PST)
Received: from 511566560828 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 4 Nov 2026 19:02:10 +0000
Received: from 511566560828 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 4 Nov 2026 19:02:10 +0000
From: Henrique Godoy <2dgodoy01227@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Wed, 4 Nov 2026 19:02:10 +0000
X-Gm-Features: AclHuK_dgHL72DQqlZJrR3IOIV4yjCUzHEWofjNRaIHKPE1uV2bQfEqfrreiTvI
Message-ID: <CAL1HEBBjmor-B9E9KjpSCh=TW_wi1AcKEwBaD69_m2UkeGWbMw@mail.gmail.com>
Subject: [PATCH 3/3] tools/mm: grow the record list instead of guessing its size
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: nt7ddrquojmdezynjw5zc16ja5115rko
X-Rspamd-Queue-Id: 911311A000E
X-Rspam-User: 
X-HE-Tag: 1793818932-958551
X-HE-Meta: U2FsdGVkX19+iEaRnWlUYomBigOVOMUiNdkMYcd7dd49Okl7TNx8Fj+dKn5aHWPGWs8OQw/DjdNTDl1eUQ/ppxy+HSJ1F5MbHZmmVJfoidwVSCoLkeFOmYaAHPJTMIvFhrm0/+1c7sTTypjqJew9dCK3uCo8+EO9lDs8Mu5jJzGMdQhHvA+vce/cwTFRFbiWM9hL3NYCPy/DnsBDGE6v5VngFILZdY1VSfSK2ec2AmdseVUu8UJ4bFNr6qvW9mU54w2h/YRJX+Vb0/wSWpIbSFpGfjZKlOBUwxhvxrF3Em+1YMJiKURjc8xW2lF3AdIB6fE5wqrI3zag1b1OriT3msGeu2Vqsu8wrTKR7l03m37SFtkiKL4kXoOTkc9AkvjkwZHOjT1PtJzIB3V0qcD09egJ4WYkyncj8tvDdcCCqPh49k7yL7SWoGJS+iV3bKJOPNiTWykrfuzArtlWmowZsPBaAG2xSZCWKYlJQni96UeoQPv6O1xIkSmP+HRRE3ya9pg7RI5eYlKic+LxmSzjpvOsrzWYNDQT4u8gqMg0mvll+QRPZBAqEM+/ANVtmrj3ZAy/XEM2NInXdG/sMb28IJkLausWrXe2hUAmYn44+YzB8IhcGDUMlspVRH7nGjqs6fgqlL0G+k19ACdC/wHPjia8pXlXx0C4IoBqgqC3O3RCFomscpAWi7IDIW4T5E4kvqV7UOWt9ZpzfRKdVbeCI5eJL8u6OrDWaaP4t0NI7WgvhYTas9FqiR/sGcO8njE36M+hh07dbDrMo5IGF/e/+szGbx99m3r7hnu76gQPDBch8q9eSZB1M/DK1LVj9hQUY9id7meMbu6LJPEImRjExS3eLwUdyapXbOTn3DqKvi7Imo1lKHJX+qb5cbe6X+D70ZplmfnqC5o8+jxwK2dndOmMWJfkwwQwdtu7rbrIXg+YPvyMACVy/yvSxiod/9HVUUPlWlOuZ22KpUR9ar5
 NC7WkN3J
 q8j195IDEska+CSkLMJle08GXfyj5q57HFAGeH9sji9xZQYUVuMjFUGb6MD3TZy5M/2gCJaHj3njd+QHr7RrsQ9MEJfyvUc7csVvT0WfE8ft54hT8BZTiLxaIpZP0sVzd0PK3EfiUuVw6wkrA4v0kgr1699duC4ltlFbgkkk/I6/UOX7X/KxeRFXc8K94WLobhYKB2E2tNmqdDhL/ULR8OkI6en63A8gdVDTeZI7K4Txr+gu+YHCdJ/fWrPq331iGNgMWNkzeDyDNAEKN3EI6nwaBRZZGDmLaMVXXtRZjGfSYpXPG0wxlwKWG8EsnpPA91a11tAtwu4M/kPBHEv7dBeeDlfupXlaYAzTTQFdDWUrT7qYuMt3fYHdDo0IrfzHrD0997M5lXDIvai4MACQDnIbY4+zoi59DqO6O3/L+aaScdKti/t8/UmTM3AItgKrkPeeNTknGHjw2HplvW0DJkaIRlbibV2ikmU+lKzokllyHmOs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

main() sizes the array of records with st.st_size / 100, and add_list()
refuses to go past it with "max_size too small??".  A dump whose records
are shorter than 100 bytes holds more records than that, so a valid input
is rejected and no output is written:

  $ ./page_owner_sort dump.txt out.txt
  max_size too small??

Keep the guess as a starting point and grow the array with realloc().

Co-developed-by: Pierre <pierre@cloudwalk.io>
Signed-off-by: Pierre <pierre@cloudwalk.io>
Signed-off-by: Henrique Godoy <henrique.godoy@cloudwalk.io>
---
 tools/mm/page_owner_sort.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/tools/mm/page_owner_sort.c b/tools/mm/page_owner_sort.c
index a042bf1..5b51cff 100644
--- a/tools/mm/page_owner_sort.c
+++ b/tools/mm/page_owner_sort.c
@@ -571,8 +571,16 @@ static bool add_list(char *buf, int len, char *ext_buf)
 	enum FILTER_RESULT filter_result;

 	if (list_size == max_size) {
-		fprintf(stderr, "max_size too small??\n");
-		return false;
+		struct block_list *grown;
+		int new_size = max_size ? max_size * 2 : 64;
+
+		grown = realloc(list, new_size * sizeof(*list));
+		if (!grown) {
+			fprintf(stderr, "Out of memory\n");
+			return false;
+		}
+		list = grown;
+		max_size = new_size;
 	}
 	filter_result = filter_record(buf);
 	if (filter_result == FILTER_ERROR) {
@@ -952,7 +960,8 @@ int main(int argc, char **argv)
 		goto out_module;

 	fstat(fileno(fin), &st);
-	max_size = st.st_size / 100; /* hack ... */
+	/* the guess is only a starting point, add_list() grows the list */
+	max_size = st.st_size / 100 ?: 1;

 	list = malloc(max_size * sizeof(*list));
 	buf = malloc(BUF_SIZE);
-- 
2.39.5

