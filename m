Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C477CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 15:09:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 874686B0409; Mon,  1 Jun 2026 11:09:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FE3A6B040B; Mon,  1 Jun 2026 11:09:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EDBE6B040C; Mon,  1 Jun 2026 11:09:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5D36A6B0409
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:09:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 08A25140635
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:09:54 +0000 (UTC)
X-FDA: 84831678708.29.DAFBDEF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1AB311C000E
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:09:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j63IPH5W;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780326592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SposVQLGMQ3g7KzUAjhtvHRJnzNQ9+QLm8OIeq0t7dQ=;
	b=ZM3f4qFBkAVL5dS2IfRL2qKjXZI2LwFcCpmcDEFmfxP0S3X8RZNKVN9AhtQQ9SN+7jWLJ4
	NV8rang193iDwDJanJefMeXhpPRrTqOQ9pXUZrSuFv+PNRFXcp0RckKEs1vCyhW8p+eiWN
	SdOJMNQ8iVuChKA7s4mVxrZHxf2lJAk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j63IPH5W;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780326592; a=rsa-sha256;
	cv=none;
	b=wv7L2ap98yiLDp37gS7oV4HPAt4ThaV45HwDU0AztxSOUg5yHmmAOqeYrYHa8nW5n/x/zH
	3hig7dd2lmLAipdXJrklnjqoX9/4PL4IBVXfe0Sx1QwwU6zIID6vyis1td1NM2EKZUFA8I
	/FrDwPbhJCbnOwdNHtHaOLc9cypVW6w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 451EE405E5;
	Mon,  1 Jun 2026 15:09:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BFA51F00893;
	Mon,  1 Jun 2026 15:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780326591;
	bh=SposVQLGMQ3g7KzUAjhtvHRJnzNQ9+QLm8OIeq0t7dQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=j63IPH5W6isuJl5Sv8a6btnJONu83KwfUpY9mdaENr9hHPZiHaIUogJyj4mgGyvD9
	 YIx7biR867n999sBxLIyeZtZczVwtoIyaIuvsMJNorqaQXrGyWYsLtEx/rHbrXkzNl
	 8+VU5bhHxvr3SocNwyI0uyt0ZhP36xDBfnSDgCn7wBmhG5mVIggYRmHHAMJVRzMcuM
	 qf2KEGIiwU/eBKCj/MPsH8ZQQcw1I7BiMIELSCm5PcUqnU2A75BsJBuBbBmvDFl/VV
	 DzWDsdLXrNWtj2ioeKU1c+Sckl4U8KELVku4lBdMPfRmZAOdRy8/fE0pPUOv2SSRTk
	 gldrLVbnV3kCA==
Message-ID: <e0a80cc9-03b3-40b4-a6e8-ac0fa00b7aad@kernel.org>
Date: Mon, 1 Jun 2026 17:09:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] mm: Refactor lazy_mmu_mode_pause() and
 lazy_mmu_mode_resume()
To: Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
References: <20260526150514.129330-1-jgross@suse.com>
 <20260526150514.129330-4-jgross@suse.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260526150514.129330-4-jgross@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 3ynswfs17ypmk9wn4rtz5s3rez8d1acb
X-Rspam-User: 
X-Rspamd-Queue-Id: 1AB311C000E
X-HE-Tag: 1780326591-61089
X-HE-Meta: U2FsdGVkX19sMTkerXPbvjlf/8EM88NqLGQhpHZumkqMwHHrrJxZnFld6VZxi+0kZ5R/PWNN1X/qCX3DFfT4332z4k3D9uU8pLDU2qNF/3Lb268CH+TVLOzJSZjyurRd3yQS3pF7dV+ETJZ0XTksphG9SfXKxir6AQ8pYWIgpzF5FkJWka9lqwy5WwrWwG3cqQ2d+d1s7WzvfNhry+k+5ZR02AbajUrU6+X4XCCoVK3hBKq/dQcMuae1ceCqOu4WnfemYiI8uc5WlogAg6yTf0UqnJaWVhqi9LyO7QF6W2jwMm2Kai9IM9Tibi54DnNt1vS1fLCzhsCsBox5sArU84i7ueYb2hlIEd7oePtMZKH3DDc8VMD8ZSZtM+sAtNvpWgbZOE/a770USFzegNQOWo4ACoBRcypEh1sYEW1KJLCfwjIAO/qwaVm6sv2YI8p3Zff/2rOnk5/AD6GFsS9PKBY9+jBNudZQUnzBgPOHTDB5yoneVXywdSVUM+bPLbsCGDRL1EcWDVgM6QU07zt2PcH0GAy7qS1iJpjJBZrHN4d+qc+VtTNVTdRcAFGj1hyyIU1LGohVdjGk6DFq0QoEuYBXfLOAXQJ9m43hQNCc4MoTynzh9Wnp28bicVtvL8zMeEmEHNFmn7RwzCNaAkoV7bpNEcDmzcl+FJGvMQehPUSzwz0S4rIsrYsuWsyeuWpAycE/eD8YNT6qjoQUXQusxK3w3jzj9IN+9tdRoiLWBp2TAYAE9j34e55UZl7Wahq4sKECrlyUugq5Q5pV/iXKfU0s3GeFjmbJ7P+5Ry60PxCzBnWlEH4UaSVwaNaJeDUfNXHhk8DYSAaTsmJLW+OHmI24cYG0vs3pFeSr5hOj7Eu2palz3je/LgQ2wrSi+A/4HCHpWFGpTYfpMdsML8G3mVjzSasK1scMLfj85ZN/gtNlbKX5m3y+mFRmgYWTb04uxA9doNlyO7SyOcZmq3B
 pH2k+hLA
 H29aGa8LYw1NY2aBYTDvZdC/a+fyDn0pATqbPs+0jS9V4PDND1TudvNb0oJl6V8F4Mp/58mbbduirhdnfvpMqlXr9G7t1sRHAz0Llb3aNIMEh7vCfIm2QSj+IIol2tIttoMAAjUpN5igMtSZezoXg2/P476H90kywZW5yX76KaUhJPzvuPAk88sNFBNgfHY2G4CgFosIGwMqSZGfrLYPx1T73z5N53Ld5Eq0C7Op5ny/ps55ul0ZLJC9NkF5D/DhlnOkp6L3ucsUvitclFsQSfQC0gcUE4s1fBJhN4xjM9WuUzZQ3MfnJkDrPXKuHZlLEOWyulX/J1eAJakKp2JtTa99AQTuG7Z/qxgadpnmgkS1Df6JVyICaxLUNswmL9hUrxk9RLpE621D+h68QxySRrE2chskMCY3fSDVwmk+8Hjd7cy70V7xZdfIoKaCLrmnmX2XPic0gJPwM8twNDdEfSQiQ9uFT6aZTusnW2rUtK96ffAM+gH3+d8fTQJusSfD1tBka
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/26/26 17:05, Juergen Gross wrote:
> In order to allow pausing and resuming MMU lazy mode for other tasks
> than current, refactor lazy_mmu_mode_pause() and
> lazy_mmu_mode_resume().
> 
> This will be needed when dropping the Xen PV private lazy MMU
> bookkeeping.
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

