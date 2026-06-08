Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD397CD8C9F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 10:14:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E31286B00A1; Mon,  8 Jun 2026 06:14:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE2576B00A2; Mon,  8 Jun 2026 06:14:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD0C16B00A3; Mon,  8 Jun 2026 06:14:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BBD1F6B00A1
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 06:14:22 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 756F1A0A8B
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 10:14:21 +0000 (UTC)
X-FDA: 84856335522.23.09D1F02
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf05.hostedemail.com (Postfix) with ESMTP id 35CF2100011
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 10:14:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=F32X9w6b;
	spf=pass (imf05.hostedemail.com: domain of jgross@suse.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=jgross@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780913659;
	b=K/5MRs/LaNURIfV2DHJet2lalwJjg+hxyBYMiiauv28sodCHLpBRMdA5Ls350nEqgN6ZB6
	qm+h8Q7UPD/r9+kP3vd3tJBXIduQiYyRvV9h09oVVO4CrW6/EBJbBJHiBmztGxx9LTZp0v
	skkj+tZuHJ2fx3aHZskcrqrE07/OhJA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=F32X9w6b;
	spf=pass (imf05.hostedemail.com: domain of jgross@suse.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=jgross@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780913659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ICUYmzYvi3Npp7Z3gMsJhlNCaTZ1S0P4tdLevTu8olY=;
	b=1oDBAQkUnE+neuIUru9Y0UVR0jLEyucFRG8upo2Nz51GXqJez08Z1MIFK4xxNW+bdF6SYy
	cNFnNJxZkNWtAbp2e3GZl6IrDlahzEinJUQTdbwE9CHV9ufwszXYvvCry8o7hbnfLHl6LA
	JhpnYvCn0FS+/onLucLWZF4Z16skCAg=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-bec43ee8ff0so584415066b.1
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 03:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780913657; x=1781518457; darn=kvack.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ICUYmzYvi3Npp7Z3gMsJhlNCaTZ1S0P4tdLevTu8olY=;
        b=F32X9w6bb+t+zcGSaxmdrql766EqNAyMa7oGssR8jO2CyRCv6RcnlA6dnRqOBjWhXk
         2zAnmwykleAjfw2CTY8NsSNnOZQf3E1Traxzmi5d4tcVEfq/JC2154MJdjV+No14o8/q
         IptIFCsSk7FvuSa341lXxR9xjfxqC+Z+OA2QPSv/09aG5XTzKwLM2VDnOKRJrskNnaC9
         pLGgzpp98yZt0n0ces2FEHl6AupbWgK1LyxpGBymbR/7szKi1J9vdrrinLS0DuaGBcUo
         zXxQHXcuODs1dMTM+pkEusRpwIGVoB/a7mxAF05g1c/UbZz4+7YaC5V/pyPaHR8OWswI
         RcOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780913657; x=1781518457;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ICUYmzYvi3Npp7Z3gMsJhlNCaTZ1S0P4tdLevTu8olY=;
        b=mY+MSKwtPv3Q/hKdFkNqvtYC88RSAMIerC659CM4NJmJsUnyNcLxPgHvB5tKMOfK1O
         L9S4Ezks6F6VjGF/zGCwKzhjqC8/NGcFZas7XHC6lrB8kBRk4DNC+UDTVVlH9Zm+r7tC
         +0P/o4qt0RsTmIuaxRCutMsZmorMU61sd2Xx3zA6aWLxKjutmYd6bGq6eW7Xb9k7FAPJ
         ZLnBSOPBm3WK1jM4Ynghy0wjcUjdP+VNc9VwemtSnoOpg5aVCa361Lll6g088wiDakqY
         M8GPD3la3+3TviPtxXZ+VOC2S2hulbqYtEGqXBdLU847WQyRwhAet9R0Qb5o7sENGVZR
         +8xQ==
X-Forwarded-Encrypted: i=1; AFNElJ/+1hexMW0xACjtg7a/uiQdFE5fIWIhJ0JBWAbvzOlc5ZhgkL9hIAYv6exdSyYsUKMr0yWeV0dGQg==@kvack.org
X-Gm-Message-State: AOJu0YzUcAMLBjt4TnirTfTYQnrTgW+NFhlZVst7koGMyDUqZFhEgR/i
	vVpcWl//cTG2BSpOyOYI2xewiR4mO7TrkVIEfNo77o1LgcQSxEtD6n7B/XhELcXsVV4=
X-Gm-Gg: Acq92OF+9cBfq/dAbsX1kYHfIdIpLcF+tkIPBDJhBxOPynCu/QUuOJbLTp3JS2qhcRX
	1/hSYYHAz/KwIQQPdSd5UQT9qOU/JRsmS4CG5Vseq2aMAEcC7JZO0ZA1y0YS1/4I6k7f4MkaFNI
	mGuITRUi/uT+kFnfFo2rXYUkEVgb3qK3WgnlqoVPsxn7l3yCujjVHqKHpaQxNUSsDY+QV23MYtt
	Tdf1ukyAIeFDhwRuy/GQLcsNJJvOLDcfF5KJM/KD5/21N2G3nIL0ThdbQLx6EFmHsgMaXHovF3D
	Df738ndy2L2W46QtE1fX+d6Bjc3zkAXNgqq5Cgln+LlcUzM3wF68Ncafo6LO5Q9N5dtcYMWn4xL
	iWZSHVq9Em/eTMuYPGq++XUmW0HBlSv5Ccx/e6y0J/zl4JLlxWY5xJ2j7PSVFSL6pURa0KdBWVh
	MDvstRWbgfSdQzcBGdEEg6Z7/RUQFJC1MSUeoy8CuX0shnfm7xYcKSSqlq8iW9lVCz/Bcxe/AX7
	nVebWVMbZJr/I2cbFxhMB5/crYbLnUuwOT5NkydT4byKHqeOk/7aBivrcpAUfu2
X-Received: by 2002:a17:907:60d1:b0:bd8:fc89:cda0 with SMTP id a640c23a62f3a-bf3a8a0cdbamr553511066b.24.1780913657464;
        Mon, 08 Jun 2026 03:14:17 -0700 (PDT)
Received: from ?IPV6:2a00:12d0:af5d:ad01:5d3f:14e6:9bcb:5112? (2a00-12d0-af5d-ad01-5d3f-14e6-9bcb-5112.ip.tng.de. [2a00:12d0:af5d:ad01:5d3f:14e6:9bcb:5112])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bf0559f1f62sm862110466b.57.2026.06.08.03.14.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2026 03:14:16 -0700 (PDT)
Message-ID: <af7a7a96-c1f9-47bb-9c4c-c83fe6a9f70b@suse.com>
Date: Mon, 8 Jun 2026 12:14:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/9] x86/xen: Convert xen_mm_pin_all() to ptdescs
To: Vishal Moola <vishal.moola@gmail.com>, Dave Hansen
 <dave.hansen@intel.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 x86@kernel.org
Cc: Mike Rapoport <rppt@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>,
 xen-devel@lists.xenproject.org, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>
References: <20260527140316.294621-1-vishal.moola@gmail.com>
 <20260527140316.294621-9-vishal.moola@gmail.com>
Content-Language: en-US
From: Juergen Gross <jgross@suse.com>
Autocrypt: addr=jgross@suse.com; keydata=
 xsBNBFOMcBYBCACgGjqjoGvbEouQZw/ToiBg9W98AlM2QHV+iNHsEs7kxWhKMjrioyspZKOB
 ycWxw3ie3j9uvg9EOB3aN4xiTv4qbnGiTr3oJhkB1gsb6ToJQZ8uxGq2kaV2KL9650I1SJve
 dYm8Of8Zd621lSmoKOwlNClALZNew72NjJLEzTalU1OdT7/i1TXkH09XSSI8mEQ/ouNcMvIJ
 NwQpd369y9bfIhWUiVXEK7MlRgUG6MvIj6Y3Am/BBLUVbDa4+gmzDC9ezlZkTZG2t14zWPvx
 XP3FAp2pkW0xqG7/377qptDmrk42GlSKN4z76ELnLxussxc7I2hx18NUcbP8+uty4bMxABEB
 AAHNH0p1ZXJnZW4gR3Jvc3MgPGpncm9zc0BzdXNlLmNvbT7CwHkEEwECACMFAlOMcK8CGwMH
 CwkIBwMCAQYVCAIJCgsEFgIDAQIeAQIXgAAKCRCw3p3WKL8TL8eZB/9G0juS/kDY9LhEXseh
 mE9U+iA1VsLhgDqVbsOtZ/S14LRFHczNd/Lqkn7souCSoyWsBs3/wO+OjPvxf7m+Ef+sMtr0
 G5lCWEWa9wa0IXx5HRPW/ScL+e4AVUbL7rurYMfwCzco+7TfjhMEOkC+va5gzi1KrErgNRHH
 kg3PhlnRY0Udyqx++UYkAsN4TQuEhNN32MvN0Np3WlBJOgKcuXpIElmMM5f1BBzJSKBkW0Jc
 Wy3h2Wy912vHKpPV/Xv7ZwVJ27v7KcuZcErtptDevAljxJtE7aJG6WiBzm+v9EswyWxwMCIO
 RoVBYuiocc51872tRGywc03xaQydB+9R7BHPzsBNBFOMcBYBCADLMfoA44MwGOB9YT1V4KCy
 vAfd7E0BTfaAurbG+Olacciz3yd09QOmejFZC6AnoykydyvTFLAWYcSCdISMr88COmmCbJzn
 sHAogjexXiif6ANUUlHpjxlHCCcELmZUzomNDnEOTxZFeWMTFF9Rf2k2F0Tl4E5kmsNGgtSa
 aMO0rNZoOEiD/7UfPP3dfh8JCQ1VtUUsQtT1sxos8Eb/HmriJhnaTZ7Hp3jtgTVkV0ybpgFg
 w6WMaRkrBh17mV0z2ajjmabB7SJxcouSkR0hcpNl4oM74d2/VqoW4BxxxOD1FcNCObCELfIS
 auZx+XT6s+CE7Qi/c44ibBMR7hyjdzWbABEBAAHCwF8EGAECAAkFAlOMcBYCGwwACgkQsN6d
 1ii/Ey9D+Af/WFr3q+bg/8v5tCknCtn92d5lyYTBNt7xgWzDZX8G6/pngzKyWfedArllp0Pn
 fgIXtMNV+3t8Li1Tg843EXkP7+2+CQ98MB8XvvPLYAfW8nNDV85TyVgWlldNcgdv7nn1Sq8g
 HwB2BHdIAkYce3hEoDQXt/mKlgEGsLpzJcnLKimtPXQQy9TxUaLBe9PInPd+Ohix0XOlY+Uk
 QFEx50Ki3rSDl2Zt2tnkNYKUCvTJq7jvOlaPd6d/W0tZqpyy7KVay+K4aMobDsodB3dvEAs6
 ScCnh03dDAFgIq5nsB11j3KPKdVoPlfucX2c7kGNH+LUMbzqV6beIENfNexkOfxHfw==
In-Reply-To: <20260527140316.294621-9-vishal.moola@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------mqeEDAX0jgEctDcOkQ0EDxdK"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 35CF2100011
X-Rspam-User: 
X-Stat-Signature: oetjpeprwxnd3fmkmc61hpx66en51yx3
X-HE-Tag: 1780913658-268688
X-HE-Meta: U2FsdGVkX1960fyqt+h5o8Lnx4bnPH+8/f3iNDgKkIE8cegK+DSBgTzMSVn9/SZ1ndgqII3FHpUiUkfBc8w3PXVl8SI+dXbgJzgY2ry8Xye8r6f9rxb5KezNw2W4oT/1f4A4ROJU3gHE8Bg3t7hrq+AAve5X8ngzL1YcteN0RRr56WNdQZAim9GMyfIqoGYCvah2o923GHPVpGfMJsYcyjFJNrfPfi65X5GY5CanMQ4NkgXZ3aOlgTLa4l8NKc1PpUb/zOeW3VqQPrOK+uYTkVE3fZ0a6OKEXAbsj+gmw7iFlGrpLjM9qGdXATipcND/BQWKfp1b+QMsdLEzt0vfWU5DcuPN8uC9JgvgCiIcfw1E3zlmDXpTZD1Vqpf9aMroZlggwTilJH8K4BxTR4dedlGAGyVmCNlFkeg31kGEcq6nz7jFV/EoCYF42yqm+jjvq5RdlTD/wXKhL9d50fO2XAbUjBQkAUfrN8wzYhouQQ7lt3UD8Yna0mCAtcAI8MH2X8FAd/q0M3jOY/6sPKZmvo3JwHh+/3RaUzrHwUgEzZvhUeVdXwG5FKdUJqhQ3FDhI1PLN+bkoxAdP3BH4ywhso0lrn8F8HHsiKTyAXRQ9I7mlSoVt95CsTRKkw5HYjTGQQVzk/nkVd8xJqSf1okg1fPtkUsJ5Ixkq00IlMEp0kq5Ptd9OSX9XE//QzXrA2GI63UWjZ7CvwHFcNRl7wzni4eS8l0FdXBrOgADbDDaC+MtTGdtnBqIEmRi2xVAZxSb1ocOiPwWz+moz/+dSoAQegDw85DL3WSWyqeGclLjzN6zQOnigZFnP1O7BHWdqc6DKZlulQYOxXgiYqJs7anYgILHJDHrCACMj+apiHCxEvFqCjk0RTQ1o0QqyIIHm1lexNRTbjNeWxMbexnpl3El4pc0TRM28SG3+VkVwyi5zoEYEdwCzuQmZ5iz0MvysnjiPVvoJVL8h/fiS3SMY7i
 D83uAW+J
 iQUeCH6RRknDoQdLgPk3+b1lx0kJh/zKAAbbIIGkta4U8Xj6p/sOen3mROIvYs/fVoddzuLXkYkY8bKtrXCCjcZiOgznMeNB0t7StHS0V+iNroeaPEDb1feGyjz+yaFidhg2+IwAMOaTRL+HMyeHRFSGgBVDpHxL5SNxpFCkELLf5GSDYai/Ss5rRl381W1oqO3yP6gpCzMqNV40AccfmpzOxY8tO+NL5/zg80uEIDRWZgEwItNAp068w8lT0hqSi2J6c27hQlmzUUnXNGk+8S1NZqc8iHptAasYc7usi2xFJC+rFw+mV0LFKld8toTOwRAnIrQyEhI4tUZDxAwCbSAg/O/M7Ik0IHYc9RWG7NUElURXQIuQqK5JeNrsJxgm87wuVTZqNwkbtu3JYzmTDl2s/ODUum91ggcfzBbVb6X3jU1/Leh16qU7hLBCuZyq03YDlOVUZTshU96DQQUSH3b4mHJmR/4aFYtWV/eCcP2jvId9F2E1GjgCcS/rRgC/Nf+obUJHcOcN1etMwuMgOMp9z/hB5w3Cim3NEut7OMKHV/QQ9RH1gdDUCRUGXeJvBh7yD6bOrpWsW1i6t9xLx4EJBXczIVOV7LGaYaVN/9mngT5ghBUWE97vpxzfxs6w57v1aPEEILlEWiqboPa/jk8mjlOpjoTna5hoLGQJpjDWf8Flqo/QwZwAbJ4tcqeCazkNER4CGcsMousnd6JO+MeIYFbSQNfq4o+MyGyaRE1nAS0ambWwuSxsZyQ1xKNMczJswvPVhNsuO7VUbydxpu47LRP+ypS1PvkgasGsvTVO1oMrQQA0ASLKskE8rT7FncOCsxgxoKvYpVZTTKa7eo4qHQvCP77L94DOPAUbWqQbBJYXModZRPHIZeTVMDBdk1kmQe+mB4o93LuVpYrNGWKsKpfT6qiM2HFKSUPWPUImw3NBN/IRKpT85xg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------mqeEDAX0jgEctDcOkQ0EDxdK
Content-Type: multipart/mixed; boundary="------------uCZRBKwpO9lYtVcfTExo30um";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Vishal Moola <vishal.moola@gmail.com>, Dave Hansen
 <dave.hansen@intel.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 x86@kernel.org
Cc: Mike Rapoport <rppt@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>,
 xen-devel@lists.xenproject.org, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <af7a7a96-c1f9-47bb-9c4c-c83fe6a9f70b@suse.com>
Subject: Re: [PATCH 8/9] x86/xen: Convert xen_mm_pin_all() to ptdescs
References: <20260527140316.294621-1-vishal.moola@gmail.com>
 <20260527140316.294621-9-vishal.moola@gmail.com>
In-Reply-To: <20260527140316.294621-9-vishal.moola@gmail.com>

--------------uCZRBKwpO9lYtVcfTExo30um
Content-Type: multipart/mixed; boundary="------------moBdeYGjNrSgg2fuugMy79vf"

--------------moBdeYGjNrSgg2fuugMy79vf
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjcuMDUuMjYgMTY6MDMsIFZpc2hhbCBNb29sYSB3cm90ZToNCj4gQ29udmVydCB4ZW5f
bW1fcGluX2FsbCgpIHRvIHB0ZGVzY3MgaW4gcHJlcGFyYXRpb24gZm9yIHRoZSBldmVudHVh
bA0KPiBzcGxpdHRpbmcgb2YgcHRkZXNjcyBmcm9tIHN0cnVjdCBwYWdlLiBDb250aW51ZSBj
aGVja2luZyBQYWdlUGlubmVkDQo+IHRocm91Z2ggdGhlIHVuZGVybHlpbmcgcGFnZSBhcyB3
ZSBkbyBub3QgaGF2ZSBhIHBlci1tZW1kZXNjIGFwaSBmb3INCj4gcGFnZSBmbGFncyB5ZXQu
DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBWaXNoYWwgTW9vbGEgPHZpc2hhbC5tb29sYUBnbWFp
bC5jb20+DQoNClJldmlld2VkLWJ5OiBKdWVyZ2VuIEdyb3NzIDxqZ3Jvc3NAc3VzZS5jb20+
DQoNCg0KSnVlcmdlbg0K
--------------moBdeYGjNrSgg2fuugMy79vf
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------moBdeYGjNrSgg2fuugMy79vf--

--------------uCZRBKwpO9lYtVcfTExo30um--

--------------mqeEDAX0jgEctDcOkQ0EDxdK
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmomlfgFAwAAAAAACgkQsN6d1ii/Ey/+
BQf+MrwoMszO2YF1wyc7UFe2jjUkzG3MxLz8ZDDIfPq5GevYLm96pwvTy1Crl6gEPPPB22CGlJiY
D641+JUpZt9XtdJ23t+p885R7nOtDj6mj6F2vt1kgutnvAf5ez+b/WbzuZh7X9zoN4aSPwJdkVsJ
6b0VXBizvpnOvxGs5U6AfEpRP99o3JpTc37aT6ksuzLtrYLH/xb78OHiI28Pxffau7lZsZDNIAWn
1/SlT86cYVBxgiG4WusRDrjBpFwGKzEsJblea4zdOtmCJEWLF6Xt9+5ZdYdD2HIO6j8ZdxLVlhTO
At8V2crdTjvp9nKmf59yq5rAC7QoRfcgMUgqwT1FwQ==
=Q4h9
-----END PGP SIGNATURE-----

--------------mqeEDAX0jgEctDcOkQ0EDxdK--

