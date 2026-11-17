Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EBB1606A33E
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 05:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.a=rsa-sha256 header.s=1a1hai header.b=Nl7ItxXF
Received: by kanga.kvack.org (Postfix)
	id 37DED6B05D1; Tue, 17 Nov 2026 00:14:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32EB76B05D2; Tue, 17 Nov 2026 00:14:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 220A26B05D3; Tue, 17 Nov 2026 00:14:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EDAB26B05D1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 00:14:19 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7E54C8035A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:14:19 +0000 (UTC)
X-FDA: 85443445038.29.226E02B
Received: from outbound.st.icloud.com (st-2003k-snip4-6.eps.apple.com [57.103.77.177])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9AAB2140003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:14:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=Nl7ItxXF;
	spf=pass (imf23.hostedemail.com: domain of m.harisawan@icloud.com designates 57.103.77.177 as permitted sender) smtp.mailfrom=m.harisawan@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794892457;
	b=fpVUrdlC4iZIhpnX97RcjC0NXFvOryrMO8XQ1kbi6UHUODQ80BiIkJucab5TfaTjOLVoS5
	4qAtqL+yoDuhobKtmNTcTjre+0jLpsofaRqzgxr9U9qzIBJjJzcZ+bTw9aYQL5pa0Ih0IM
	XWnRTL2ezQzFx3iYuFm1raJNKUt199E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794892457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rFpQXKPlCdPMLz8JSDHkl4x+ujLoo0EQsl3KWmm/frc=;
	b=awXxsIkRteBiPkQf47kf0+sC0bPCwZWdd5lkrIL6SdwHxc+KIpWrjmcnvkQW0iM2xjyQ5w
	H5XfgWAqWdOncwD78dL0aha6lBk1AEYtCWbIywLBWBOjUa8SKNOLemEHZwqFYn5xVK4ZBm
	ew7EK6MKtc+HldbQ+tDBLTW7kgVeL90=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=Nl7ItxXF;
	spf=pass (imf23.hostedemail.com: domain of m.harisawan@icloud.com designates 57.103.77.177 as permitted sender) smtp.mailfrom=m.harisawan@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-60-percent-9 (Postfix) with ESMTPS id 77891180010E;
	Tue, 17 Nov 2026 05:14:13 +0000 (UTC)
X-ICL-RepId: 01a1e7ed-5618-7ba4-8527-1cd51ee82ef2
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1794892456; x=1826428456; bh=rFpQXKPlCdPMLz8JSDHkl4x+ujLoo0EQsl3KWmm/frc=; h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version:x-icloud-hme; b=Nl7ItxXFhepaQv6lWhRwEVc6ywf1gqKAQ1KAVSfaE9o0SRX/17X+kfCZWRlPY6owZeFzIUrUhBEJLhSwB7xxTKLSJ6B8qeVAJUzH6oS3f/bFE/7zratCp4xykvXaI8EOITiSmkgi+Wa4jHf9EZ8EyQYRyZ3J+4pH3owv81Ov7/fKU6DuKgCr9g60k9bK4Gn+O3mJ4hRdJKuXYSA9kmhNTdt/fii04TJnU4C69XLcTSuiQZYdINMTVF/ZRYwgquOUavnyCE6R+OWeylBo9eyqpewJAneMKr2kSBcR4qKHpDJfLhsxhwt2ylcaKA7PF9jafjf6hA1qXOibuZUswffGRA==
Received: from [100.126.217.91] (unknown [17.156.216.30])
	by p00-icloudmta-asmtp-us-east-1a-60-percent-9 (Postfix) with ESMTPSA id 5069E18000BE;
	Tue, 17 Nov 2026 05:13:55 +0000 (UTC)
From: Muhammad Haris Awan <m.harisawan@icloud.com>
To: Barry Song <baohua@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
 Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan: respect can_reclaim_anon_pages() in MGLRU
 get_swappiness()
Date: Tue, 17 Nov 2026 10:13:16 +0500
Message-ID: <179489239628.782731.11917939777323828511@icloud.com>
In-Reply-To:
 <CAGsJ_4wzsCm_BBh3B5s5K=c07bRk72kacU5vbzCbn_U-AvSWEg@mail.gmail.com>
References: <179488434239.3564555.16227252580122398690@icloud.com>
 <CAGsJ_4wzsCm_BBh3B5s5K=c07bRk72kacU5vbzCbn_U-AvSWEg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE3MDAyMCBTYWx0ZWRfX32TLuEe9YpFQ
 gGWRaqkEuvNxrX0574064J79eMa6YFwO/SVUwXqdJndk8icyU3o7JzNCGgk8GOzeu8MmsuXqBEp
 7kk+jmNcegl8UpyqnwlbNgBnGcKGhy8=
X-Proofpoint-GUID: eDdkUlIab-OFvnu5FlkRGTJDlp6BSc5j
X-Authority-Info-Out: v=2.4 cv=Cqcq4X4D c=1 sm=1 tr=0 ts=6afbe2a6
 cx=c_apl:c_pps:t_out a=oyWFxbOnq+dmhQrAPgaJYA==:117
 a=oyWFxbOnq+dmhQrAPgaJYA==:17 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=x7bEGLp0ZPQA:10 a=2kFROKt5_e8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=kibvr5HLtuNvmma_iept:22 a=NVRLzpS9o0UsCidzZbzm:22 a=5xiRMmjtFLm18GaVJFsA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE3MDAyMCBTYWx0ZWRfXxcTqaRNGbxyf
 YT16QBrHo87COwQrKjZWf620J/s1m9LEEz0RaUf2oEDq+F/ImnNVDjDNMZ+Pa2oeV1NoRMEDft4
 VVDk6NaYiQbK2ZfSNvr8oiJhB90iB5y4rnhJ9aWULrcjiFusy1fd2a9Vj18qicNBYzMPmSMkdV2
 wuZcMGbIAbaxfhK9exNzmQkgabaq5Ugh6eDSPR9pZ0S//mT+27G7fZqonUaVqQJ8VcTRbskqBp7
 nc5rabHmrGRHStfVsGucrEq3u+yX7sE/Brftg6f7eVDe3o0vukSGeN+evvNP2+HK2AkdmiO8JGB
 1VC3JF/mjst2gtnkO7rV4tPD7V28u11GQuccpRbSYqx5YMHGPkaNo9mcUASwAs=
X-Proofpoint-ORIG-GUID: eDdkUlIab-OFvnu5FlkRGTJDlp6BSc5j
X-JNJ: AAAAAAABCk8ABhGRbyv2LTbXCgXaKvCtkh3xi77wF4rPPWK8Yv1hEsuwLXsSGfZlDmSA2R
 79YqDJyV6DOZyk32QkcFpq1UJ8D4tVbljt5zfZnsfzBV1js6nKXdepXLctwVxEGZ8DPM6q
 3eJw0gkSFLtX3P9D2eXMaerdalrVOfDBCmxbSKV+L03tmdFdKMWgAeTZYrjqskcAbHe/1b
 OUhRxmHu5ERxHCPasIrsC6UPR2YC0vlTeo0gXNyoGPwulKyEDIjBrYjgHerobKAci5padR
 rlPcUpk3k87f++AylNZ7gOSfjUfbkDhwl0wJJ93EQnUjcqK/k5cy6lEac/INGlRHe8Mwtn
 sm8Xfn4rWpiwNCEJvBbqKpO45UAApZBYf7+DEOkEE+g+GBON28BBFPJ30gPHb7Pgfz4svR
 hmC0G9X4VDCrIq+Spu6X1d7QgZxUiirFFY+lYuDqlXMvHUkFrK4HHcTS9IVjjQrhGxJKWk
 wyWIwq/uuqt6NovWmN/VQ/YfIofoJBJB5gOX4bW9eeH/oNwqGYFEeoE54ixBtXLHp0vMMT
 x/mBUU1bZDFqlpXbTsBqR/sHb0v1atpwcrdN+AhB3kZkQgD6RFzsW+3ismo8EcEcNL05Qf
 TJpOBHfIS0WtNi09sk2/9sCugdPjLRPTWGiIsmDNGioSgG/CS3bZNoHdtquT6hbYDDrjUh
 CG5grbqme0C3eo/83w9lFLlK0RgffmJ/ewYFXR2NBNhK40NghX9K8HjbIfbaFboE2sjAiM
 pbFCVBnkyaB9sKhNftSq7oJZIWA+MJv/1Ga+0gNi1FDq6PGi4giTbCTG3c4Hfnbo64Ne3p
 kwfWJSNKRGA2JwziWLmdNvC6UeRdU2KVEfjgbSx69aMFOerJW7M9Mutp5VQA5CKhtLuR1H
 RULt33nvY72k+QHlFMbrh+t6/rrCxMxFhkjCrFM5rMmOwiSOyeqFHf1mwMuQM8DTLRXjoF
 hUDbR3dEsNxlL/tm4xBpOR74r5Ch2wkfU7nQtIFW36FgYRBuABReIFu3/eTsHgVXH/qNwx
 5PsumQf3zz4mDyT4HFqaIyNKJbFIwJMiThdbpeNUbxw6gKc9P198Zac6V6XfyvV24OMnNC
 tAXz9jsHTuHZp3umB5KcdzoFnTRiCzKn7AYIgoa/rvz5vCD+l7bgN1GaGAGCTvntKQi3sQ
 0AuFZk95jSy0allPDrSlAzQ7Xbj6yp/E3EX58Mc5o7iEdOIr6IzTMk0j8J0Zjr0P6AQRFG
 MNi5EquX9WXqnyYXPnxaxW3gnITceSkslG7bEHRocI4EozUiwD+k4hmTp3ArSwe+yFQUQ9
 f7JB/JZc+kzJu+s8VA6MDGJM/uanzOKS6jZRLdYFOMj9zl893PY/EqJbJh5e54ABs2NlwU
 y3L2viICvl7Rw4pZlipVW9bBpb0+3MsJzOZW7Wfbs3f/exQZBKRfsQH3y+muPfLortRAIR
 MfW2INNw==
X-Rspamd-Queue-Id: 9AAB2140003
X-Rspam-User:
X-Stat-Signature: mu86peppwce7myxowyed59dy85x43z6k
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794892457-553605
X-HE-Meta: U2FsdGVkX18kyLVAACdSNtDG/k5cvySECYlWQ2OBMNODi6hrHquhwn3mWhxDyR6+jtfwhHxVYKEZm7i/Qy8OFcQHBGGIir/AFB0szqcJ1A1eQtu6zrHopIVjkkBJwL46kseQ2TMzEcZAX01OVugIqG8Ttq1PZeZSnVZpkMMIl7ZP3IaKV54VNycDt+MSbArfOpuQuMBoKquc480FEqZgHPayIJeXssPnXwPK86fVSf5n5NN+hisUqCEOSRvnhsXi1zOhQ+royrOQJLKYAHAbpONp+3WE0kl7g1Tpe661Us2UxFz+fdnjg+5jBUMPPrK8oqshTR0vb4Zx+xa+qBPKn4ZS1I2AoLFAlYt948/pQCxCwbKEDoeQFYXMJm7RwP8rP+wa13SOfw8hgN9NEzb6a6l7VJ66UKAVuCYMkLXWkdDYZBVvqLMH5UvryqhWyGnTP7UgosNiLfD9w47WA1oiBQRNY+7a/7rviJS7SFuXYvxVzYZv0iT7NIDw4oXbcR19p0yRMU0yAClLaIpLfGUixj1Cemmm1BcyVgR5LnAUJ5QiRhJoWNZr8dsZdhM4gQwmCSEAWR88iC+1m4SpJT8V1HcK7kElcutzE95O8NzXh5XmNZBAK3W9dJDaIBlR3hnU+cjMPDC58R1gU60gDYaIwkjYo8QArevlc6WXhlJoYAjsm3Iw5jw5lDRZ6SR9f+iU6gp4kSg6Uhn+dSjVLWNi9UBaVK9UHfcxPxd4CV9XRZwzHRoa27+7okBUoFXr6WPsaOmYSa+ZG1Hsdg9MGL6OQA6trAFm3MaEDiS7CUG2X5H+SslcR5wBWpbvmK7Vw4ldvnisFucc/o4BQhUCccmd/53YSHWIxqO/O4XQccQJVCLyLacLtsevIlhv4/6A6O1cXUlUsI7CMDT5RQlUz5IMywJH3qyZ9ow6DuTmqBEaNjfiWeKC1+8l8hf0DGpGPFOud3S0PPHw2z9Z9eXrTUm
 cazkVZH7
 4IUXJ0h3Ui0aiQ0LzR+vC3UcFR1kVonDMEtNmsA0OCrvQgWMltTqSkFaQ27GCw+SL7P6KMc5mOXmwYBELpU8JWTM/BwV/Z2VZDNfogV5r/xD371vQqyMuGIPwEwzTzjveo/xwshMvp8BbxL3MTLAOra3+y6qqyQYMfKfc0EqK9cv6zLl327gjyLgEh4Im5YNBsteIyCVLIl6Zi9iW3XyZ351ijmsvr8S0tK4NFXI9w2rQMkjagHZ6qHOqBH2wZp0DnMU1ql5IkWWfTdKI7X/HB5YzetZWkqIgb8KGVPa5SMxVQK19Aaixm5+Kl6l7f3ujgjBl0uJjsAN5oLPjBpSFRJL5SqorrruoEd5/f+zh1n/nO5iukNy0Ez8HTiTLq7eEwVdQ3Z72k6ax2LSoVfCEvEuwrYAW6waPdtTJZf1mZXWZRVQpLAO7VXr8Eaaw7uaPqFSaluUpz08r/rlbq9aAgpUajTfwDsw/yWxX06IUMqkvf7L9FhKo0OxVh1ncrFmiuwrPtc44IzGWGJXwJfGxO6gYoxWcrVAH10s3WQk27lUKFGPPPiojCihnZLg1srOHAzrO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Barry,

Thank you for the explanation and the pointers to [1][2][3]. That makes
complete sense regarding hot/cold inversion when aging is also gated.

I'll drop this patch and take a look at your series [3].

Thanks,
Muhammad Haris Awan

