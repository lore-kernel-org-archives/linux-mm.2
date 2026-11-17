Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5F45606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 21:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=XSc3eQIM
Received: by kanga.kvack.org (Postfix)
	id CB1446B05BF; Tue, 17 Nov 2026 16:24:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C62696B05C0; Tue, 17 Nov 2026 16:24:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B797F6B05C1; Tue, 17 Nov 2026 16:24:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8F9406B05BF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:24:22 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 29B2BC05C6
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:24:20 +0000 (UTC)
X-FDA: 85445889480.06.81FA51B
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf20.hostedemail.com (Postfix) with ESMTP id 45F251C0006
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:24:18 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=XSc3eQIM;
	spf=pass (imf20.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794950658;
	b=3Av15E5ahERwgymvbKCjX93PwpGzExwENQaQxlNqxEw7xV2Lb84vbtkaK2u71rSFFR8g6N
	lbQXG6RQZetocfZXj5UlZVyUrGVCOec7zWCLYrU8HFcBqyutoi5r4DRZX0vwM0PhO3uZZo
	Kn3jwkan/2UvjRRWVq88gUbGNbW7+h8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=XSc3eQIM;
	spf=pass (imf20.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794950658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J/fjCpBeMUF8gNXxUY7RYX8CVW+S81rP+s0YQaibwOw=;
	b=K+izt2Z0QeO34Qu7WTpLRfqcNIR7p+EqfSlh0lG4inUZJUqyrCABAamS07RU/MZYIH5+OT
	q09EhZr1raNzOJnTiTOZAW5SWzAk+gNeCcEQvrKcCgWvRPDM6/8FpIjdSIJUVC7vPwbHCZ
	AoJmPiXiHpYetNQh+Z2KpEgpmzMaZms=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2efd432714aso1188265ad.0
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:24:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794950657; x=1795555457; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=J/fjCpBeMUF8gNXxUY7RYX8CVW+S81rP+s0YQaibwOw=;
        b=XSc3eQIMalKzYcilUdp9fU2ZhY68g9UMM04IuLaP3xdf8cpShkuk1ZJbPFSCyIQvh7
         W+DRQ/4WGv5E8dj0BA0NdPTemIqKbc/tCf/ScaKm+pyCfkyzzGxyuil9VpYh7jpibmnH
         MrZ/LHhzw5dcu5RArt+NkgqMYSNml6gj42UfvodMSoSR98X3rYPK1x5LDL7DdHJY2Zdc
         KZOJjKgdP6a7xKePVpaPhD16ZtCb0bWKW8CNbTfGBM+TlvsAUbol6BeBbg+QGAEd/a9O
         RuhNRRJRg8X5l3+mGGWN8Kgscsq4TE3HOg8nViilylOSvBPjB3rgXNATi/pYedXtOPC0
         T2Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794950657; x=1795555457;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=J/fjCpBeMUF8gNXxUY7RYX8CVW+S81rP+s0YQaibwOw=;
        b=Ijq6iaBLCGLqNKn8zYifpT5LN86BtL/S89EgB7oCq/yeRP3BVKXoM/4C+tL3hJHVHX
         y80jmYHIZsU7sbU5031GdGsVgPV8nYxUZ+Mz47NFtuRhINjzwxQZK147VAVCFdOP9Oag
         0Mfk5U1a6rJiu+HpvZ1+JC5jVc4YNPM/rKKZ7JyotE5crTaMr/N5sxhnubbPCNJfdCId
         jgtN6PTvD2eZHDdTJ410NUIBcYx2zPMdEaBMKbVTMhD/f/zve16EZCVq6xnGNEoUgRgf
         3Q9X7wikeaiL7B88+zDbgJ898dX1ZhUdIgzzaoeeqkIReD0YRD6vMz0N/5/pEYkUzD0b
         Ah1g==
X-Forwarded-Encrypted: i=1; AL+hErG/JqhC/xPtgbiIzTUmV1b2rt6lVAUusbmCGpmGmDiyDmmzOAE/0h0UjkkVQ/D2ArjPw/uhXF+CDw==@kvack.org
X-Gm-Message-State: APuU4Z+5/HMYf8NQtQvcoLcy9FngSEI6c4UtB82X8kuG3Q5DRCQ3uaPe
	Ov/wIqmRuavhIOvAbX4f+7QxGBiABZmqlpJElxJ/40Z3cVVJFyJFMRSUR1OYcZFFRQ==
X-Gm-Gg: AZFdTZdX/fpfcIbJSOHzzcjQ1ZC8W/n5FbDEY/sGUEv7qs5CdAXRod3fNXcHSlBpYPS
	43HtuMmG1LYcKp6UvhXWkaZ1VOFqJWxpmt5drfnWc3ohxYw0JOpcBwNaz7xV1XFnHLF+PxRlvPO
	pvMx2BkNeUEa40ioAHsh0PYGJ0yzReXogtkGu4Ghdb1t8Crigd44qZMzeH9bnSKvjQ6znrS7Kqw
	22W1nF0ra9idUv2fiJ6cve+A1l+m8NtjD6zkOiIsdAZQfOGAKONrdHZtNr390Z8g689IACeDzy7
	ulP5miG4goPrBDpu2Nxijq1kCKv5ZFL+pd4lE73bHcMdAwinsGuvZ2uv68W8DiQ58UTZdWSV8yl
	jDJ0KhwcKTvs3hQJ/ANBNZK0cbAz+thl+5ATi2M0+JljQtLSEexeYW5xwdfPJpnN++cBGa44U2y
	p6ZyHlP78jbnVNXhS22UaZQRP8zAXV5B+Jp3aFGWvrwO033EtcBfEDWQ5y71+cmC4e4Be79tIVo
	YoMkp2xN2FSYxWRLbC9q6nAiW23s/ow9PwBtUGgmABZ/KyKnCPVDrVMv0afB8C55oRvolRjD+d1
	jYeVMlc//dlU61Oh6qEmcdnLJdFlsM2whms9QOG0ivkiUezoLDeha2CyoyOMy6oX
X-Received: by 2002:a17:902:d583:b0:2ef:ee74:78e with SMTP id d9443c01a7336-2eff72ea998mr4954175ad.13.1794950656357;
        Tue, 17 Nov 2026 13:24:16 -0800 (PST)
Received: from localhost (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eff617eb61sm2650725ad.28.2026.11.17.13.24.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Nov 2026 13:24:15 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 17 Nov 2026 13:24:15 -0800
Message-Id: <DMXSWJDPGJLE.30NVP7WQSZIZ7@google.com>
Cc: <kexec@lists.infradead.org>, <linux-doc@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-pci@vger.kernel.org>, "Adithya Jayachandran"
 <ajayachandra@nvidia.com>, "Alexander Graf" <graf@amazon.com>, "Bjorn
 Helgaas" <bhelgaas@google.com>, "Chris Li" <chrisl@kernel.org>, "David
 Rientjes" <rientjes@google.com>, "Jacob Pan"
 <jacob.pan@linux.microsoft.com>, "Jason Gunthorpe" <jgg@nvidia.com>,
 "Jonathan Corbet" <corbet@lwn.net>, "Josh Hilke" <jrhilke@google.com>,
 "Leon Romanovsky" <leonro@nvidia.com>, "Lukas Wunner" <lukas@wunner.de>,
 "Mike Rapoport" <rppt@kernel.org>, "Parav Pandit" <parav@nvidia.com>,
 "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Pranjal Shrivastava"
 <praan@google.com>, "Pratyush Yadav" <pratyush@kernel.org>, "Randy Dunlap"
 <rdunlap@infradead.org>, "Saeed Mahameed" <saeedm@nvidia.com>, "Samiullah
 Khawaja" <skhawaja@google.com>, "Shuah Khan" <skhan@linuxfoundation.org>,
 "Vipin Sharma" <vipinsh@google.com>, "William Tu" <witu@nvidia.com>, "Yi
 Liu" <yi.l.liu@intel.com>
Subject: Re: [PATCH v10 08/13] PCI: Save and restore the ACS Control
 register and Egress Control Vector
From: "David Matlack" <dmatlack@google.com>
To: "Alex Williamson" <alex.williamson@nvidia.com>, "David Matlack"
 <dmatlack@google.com>
X-Mailer: aerc 0.21.0
References: <20261013162529.1928093-1-dmatlack@google.com>
 <20261013162529.1928093-9-dmatlack@google.com>
 <20261116171017.2342bd11@nvidia.com>
In-Reply-To: <20261116171017.2342bd11@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 45F251C0006
X-Stat-Signature: owj35quia9mg9huufaz7swfgsc6z64sw
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794950658-784233
X-HE-Meta: U2FsdGVkX188zRLSxX/hht/w3Hf8KXQ3il2up+Q6Sk9gHY9SRAzgy2PV99d4ScLLyL983ycQDf3qaYjw/t6OlxCgV57mKh8pxfzF5KqD1OatCj1tchksEdSbArgvwgUy82+SgxMAiFRYKC+Pq51vluKGpbVK9ruje4EEUQVo35dI8ErTuYUS94AFNTRWVE71qYwlfmQAnNv1IWe6mjxqQJWAhK/1RgRdFYK4XVQW2rfYlKBDlqLnn5B6HaUxStEyWtlLQDPEkx9ls3OiILmHd8+CxO/dKZBYmpp69szf+6AotCQd9oABg3rAXb1ZkzgH2i5l+/+O/kC3iRJWC6jtBmek3jjCDHK5c0zmmo4YxvXHnOsg1iNroxI1YVgOvOVEuFi1qiQ6hQOjqiMS7+eqYjo8Rw0NOHAb4yM3QrA4p+/4faMyeE6MB3jFYpWHvB84SQovukBaKoMLh6E4osXUUbMe5zSHHhvMbvndWqF9M2fWSPYJcZaNg31g/omWwdQIv5yrvdx26OnxcmQD1lAuL6YXxsHnRwZUcI0unGgIJLy3v7mUiy4wChb+HWuzM/IIkLKX3dJdCe9U4tK++q34sOVOTiNIc5vxW1ILW4Ict+Rwnv6e5UUjxJtQpW1KuG6UBmoQE3JlQfkF9ONcppXhrBm9TSS+5A21c3UsmKdO5N1pLS9YryZFmQrSrDBfoYLycca7nj7S7USeYgZBy98z3J7/PsBedVzE++TN9la4Q/hUDxNMjoOSbqQSHdSiMBcJen78dPyJqOfr7q9E3N2/veTkS0I7Yw7EylcfA+Ds/ZySa2zRDxmW5s4P4Wlc0Wy8SB2wE8i5arlCYqraFVVVRoZXMtptmcD5sCL9XWP0owU9PSyHcKDE65kkS77PycyvzkXIpO3/3I28lmMojXyz4G0sCzzgSVTq2sUyYpUxIPxfNRg2I8oiUPtoMxLk2ZOJy/WPO8DIGypCRfSIe72
 XwEb6l7q
 MUqngXXvbNF8ZQ8tOeGwSZ+txqRVMVoWRoZuO2+neolL/VlF6mJ/BXe7bb0yv48fJRg3r21tPBYq1zJ6PTzBKj6hmZGD2LmL08NY7kMeLUzwJTubhCdZpl6ybFLaa91gGPikOouX7n1rySDrh4egFbO2INaYvxVZHVhkr1eI2i/dziw6NeI4vi4L7bKM1AH9ub2aEz5zOd/it2xD+pSH4rphzYPUaVARypoVg68AIMXxafZwAJ6hDtdl+n0jF1O0ISJ5tQkbHF+qrFkiDVSLU+zHJLabC1gOUcU81VIhxbwJjKFoh8hvXopQfiMC7ti4HQfJpj4SkDLho/30+H9CFE2Ypq8wUmAmKLNizM+fxGjXEZcXFB1SB85CxObC8G/VQHXOq7LmQW8R4SpmG1u+Xr0hM3+5hYMlVi+4wRou98yQR8eK6WK0KHvNbs8QTJRisrPHb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon Nov 16, 2026 at 5:10 PM PST, Alex Williamson wrote:
> On Tue, 13 Oct 2026 16:25:24 +0000
> David Matlack <dmatlack@google.com> wrote:
>> +static void pci_allocate_acs_save_buffer(struct pci_dev *dev)
>> +{
>> +	size_t size;
>> +	int pos;
>> +
>
> Nit, moving the device specific enable test here:
>
> 	if (pci_need_dev_specific_enable_acs(dev))
> 		return;
>
> Would avoid:
>
>  - Allocating a buffer that will never be restored
>  - Saving ACS state to a buffer that will never be restored
>  - Testing for the device specific enable at restore
>
> Otherwise,
>
> Reviewed-by: Alex Williamson <alex.williamson@nvidia.com>

Thanks for the review.

I'll make this change as you described. Preserved devices will still
need the buffer even if they match a device-specific quirk (see my reply
on 09), so 09 will also allocate it for devices that were preserved by
the previous kernel. Since restore then just checks whether the buffer
exists, that is all it takes for preserved devices to keep their adopted
controls across a reset.

